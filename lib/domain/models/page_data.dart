import 'package:equatable/equatable.dart';

class PageData<T> extends Equatable {
  final List<T> listItems;
  final bool isLastPage;

  const PageData({required this.listItems, this.isLastPage = false});

  PageData.initial() : listItems = <T>[], isLastPage = false;

  PageData<T> copyWith({
    List<T>? listItems,
    bool? isLastPage,
  }) {
    return PageData<T>(
      listItems: listItems ?? this.listItems,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => <Object?>[listItems, isLastPage];
}
