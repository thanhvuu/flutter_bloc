import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc_app_demo/domain/entities/cart_item.dart';
import 'package:bloc_app_demo/domain/entities/order.dart';
import 'package:bloc_app_demo/domain/repositories/cart_repository.dart';
import 'package:bloc_app_demo/domain/repositories/auth_repository.dart';
import 'package:bloc_app_demo/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  final AuthRepository _authRepository;
  final OrderRepository _orderRepository;

  
  CartBloc(this._cartRepository, this._authRepository, this._orderRepository) : super(CartInitial()) {
    
    on<LoadCartEvent>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await _cartRepository.getCartItems();
        emit(_createCartLoadedState(items));
      } catch (e) {
        emit(CartError('cart error ${e.toString()}'));
      }
    });

    on<AddToCartEvent>((event, emit) async {
      try {
        final profileResult = await _authRepository.getUserProfile();

        final currentUser = profileResult.fold(
          (failure) => null,
          (user) => user,
        );

        if(currentUser == null) {
          emit(CartRequireAuth(DateTime.now().millisecondsSinceEpoch));
          final currentItems = await _cartRepository.getCartItems();
          emit(_createCartLoadedState(currentItems));
          return;
        }
        

        
        final currentItems = await _cartRepository.getCartItems();
        final existingItemIndex = currentItems.indexWhere((i) => i.id == event.item.id);
        if (existingItemIndex >= 0) {
          final existingItem = currentItems[existingItemIndex];
          final updatedItem = existingItem.copyWith(quantity: existingItem.quantity + 1);
          await _cartRepository.addToCart(updatedItem); 
        } else {
          await _cartRepository.addToCart(event.item);
        }

        emit(CartItemAddedSuccess());

        add(LoadCartEvent()); 
      } catch (e) {
        emit(CartError('Không thể thêm vào giỏ: ${e.toString()}'));
      }
    });

    on<UpdateCartQuantityEvent>((event, emit) async {
      try {
        if (event.newQuantity > 0) {
          final updatedItem = event.item.copyWith(quantity: event.newQuantity);
          await _cartRepository.addToCart(updatedItem);
        } else {
          await _cartRepository.removeFromCart(event.item.id);
        }
        add(LoadCartEvent());
      } catch (e) {
        emit(CartError('cart error: ${e.toString()}'));
      }
    });

    on<CheckoutCartEvent>((event, emit) async {
      try {
        emit(CartLoading()); 
        final profileResult = await _authRepository.getUserProfile();

        final currentUser = profileResult.fold(
          (failure) => null,
          (user) => user,
        );

        if(currentUser == null) {
          emit(CartRequireAuth(DateTime.now().millisecondsSinceEpoch));
          final currentItems = await _cartRepository.getCartItems();
          emit(_createCartLoadedState(currentItems));
          return;
        }

        final order = AppOrder(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUser.id,
          items: event.items,
          totalAmount: event.totalAmount,
          status: event.status,
          createdAt: DateTime.now(),
        );

        final orderResult = await _orderRepository.createOrder(order);
        await orderResult.fold(
          (failure) async {
            emit(CartError(failure.message));
            final currentItems = await _cartRepository.getCartItems();
            emit(_createCartLoadedState(currentItems));
          },
          (_) async {
            await _cartRepository.clearCart();
          }
        );

        
        add(LoadCartEvent()); 
      } catch (e) {
        emit(CartError('cart error ${e.toString()}'));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      try {
        await _cartRepository.removeFromCart(event.itemId);
        add(LoadCartEvent());
      } catch (e) {
        emit(CartError('cart error: ${e.toString()}'));
      }
    });
  }

    
  CartLoaded _createCartLoadedState(List<CartItem> items) {
    final subtotal = items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    final shippingFee = items.isEmpty ? 0.0 : 12.00;
    final tax = items.isEmpty ? 0.0 : 22.24;
    final total = subtotal + shippingFee + tax;

    return CartLoaded(
      items: items,
      subtotal: subtotal,
      shippingFee: shippingFee,
      tax: tax,
      total: total,
    );
  }
}