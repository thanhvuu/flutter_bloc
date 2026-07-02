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
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError('cart error ${e.toString()}'));
      }
    });

    on<AddToCartEvent>((event, emit) async {
      try {
        
        final currentUser = await _authRepository.getUserProfile();
        
        if (currentUser == null) {
          emit(CartRequireAuth(DateTime.now().millisecondsSinceEpoch));
          final currentItems = await _cartRepository.getCartItems();
          emit(CartLoaded(currentItems));
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
        final currentUser = await _authRepository.getUserProfile();
        if (currentUser == null) {
          emit(CartRequireAuth(DateTime.now().millisecondsSinceEpoch));
          final currentItems = await _cartRepository.getCartItems();
          emit(CartLoaded(currentItems));
          return;
        }

        final order = AppOrder(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUser.id,
          items: event.items,
          totalAmount: event.totalAmount,
          status: 'PENDING',
          createdAt: DateTime.now(),
        );

        await _orderRepository.createOrder(order);
        await _cartRepository.clearCart();
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
}