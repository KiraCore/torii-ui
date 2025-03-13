import 'package:equatable/equatable.dart';

class PageData<T> extends Equatable {
  final List<T> listItems;
  final bool isLastPage;
  final DateTime? blockDateTime;
  final DateTime? cacheExpirationDateTime;

  const PageData({required this.listItems, this.blockDateTime, this.cacheExpirationDateTime, this.isLastPage = false});

  PageData.initial() : listItems = <T>[], blockDateTime = null, cacheExpirationDateTime = null, isLastPage = false;

  PageData<T> copyWith({
    List<T>? listItems,
    bool? isLastPage,
    DateTime? blockDateTime,
    DateTime? cacheExpirationDateTime,
  }) {
    return PageData<T>(
      listItems: listItems ?? this.listItems,
      isLastPage: isLastPage ?? this.isLastPage,
      blockDateTime: blockDateTime ?? this.blockDateTime,
      cacheExpirationDateTime: cacheExpirationDateTime ?? this.cacheExpirationDateTime,
    );
  }

  @override
  List<Object?> get props => <Object?>[listItems, isLastPage, blockDateTime, cacheExpirationDateTime];
}
