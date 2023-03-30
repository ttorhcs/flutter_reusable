import 'package:flutter/material.dart';
import 'package:flutter_reusable/components/widget_builder.dart';

class TextSearchPaginateField extends StatelessWidget {
  final bool canPaginateNext;
  final bool canPaginatePrev;
  final Function previousPage;
  final Function nextPage;
  final Function(String) search;
  final String searchLabel;
  final String searchText;

  TextSearchPaginateField(this.canPaginateNext,this.canPaginatePrev,this.previousPage, this.nextPage, this.search, {this.searchLabel: "Keresés", this.searchText}){
    state.searchText = searchText;
  }

  final SearchState state = SearchState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: textFormTextWidget(
            searchLabel,
            state.searchText,
            (text) => state.searchText = text,
            null,
            onFieldSubmitted: (_) {
              state.searchText = _;
              search(state.searchText);
            },
          )),
          InkWell(
            child: Icon(Icons.search),
            onTap: () => search(state.searchText),
          ),
          IconButton(icon: Icon(Icons.arrow_back), onPressed: canPaginatePrev ? previousPage : null),
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: canPaginateNext ? nextPage : null),
        ],
      ),
    );
  }
}

class SearchState {
  String searchText;
}
