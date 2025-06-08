import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'buyer_state.dart';

class BuyerCubit extends Cubit<BuyerState> {
  BuyerCubit() : super(BuyerInitial());
}
