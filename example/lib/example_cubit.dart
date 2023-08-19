
import 'package:request_builder/request_builder.dart';

class ExampleCubit extends Cubit<FlowState> {
  ExampleCubit() : super(const InitialState());

  static ExampleCubit get(context) => BlocProvider.of(context);

  void emitState(FlowState state) async {
    emit(state);
  }
}
