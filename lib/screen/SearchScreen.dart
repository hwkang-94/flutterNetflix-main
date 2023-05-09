import 'package:clonenetflix/screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clonenetflix/model/model_movie.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // 검색 위젯을 컨트롤하는 _filter가 변화를 감지하여 _serarchText의 상태르르 변화시키는 코드
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  FocusNode focusNode = FocusNode();

  // 상태 변호 감지
  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }


  //firebase에서 데이터를 가져옴
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream: FirebaseFirestore.instance.collection('movie').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  //_buildBody()에서 가져온 데이터를 필터링
  Widget _buildList(BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    for(DocumentSnapshot d in snapshot) {
      if(d.data.toString().contains(_searchText)) {
        print("_searchText : $_searchText");
        searchResults.add(d);
      }
    }
    return Expanded(child: GridView.count(
      crossAxisCount: 3, // 한줄에 3칸
      childAspectRatio: 1/1.5, //비율
      padding: EdgeInsets.all(3),
      children: searchResults.map((data) => _buildListItem(context,data)).toList()
    ));
  }
  //GridView에 들어갈 InkWell로 그리고 그 누를때 마다 디테일 뷰를 띄우도록 함.
  Widget _buildListItem(BuildContext contextm,DocumentSnapshot data) {
    final movie = Movie.fromSnapshot(data);
    return InkWell(
      child: Image.network(movie.poster),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<Null>(
          fullscreenDialog: true,
          builder: (BuildContext context) {
            return DetailScreen(movie : movie);
          }
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black,
            padding: EdgeInsets.fromLTRB(5, 80, 5, 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 15),
                      autofocus: true,
                      controller: _filter,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white60,
                          size: 20,
                        ),
                        //우측에 배치될 아이콘
                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _filter.clear();
                                    _searchText = "";
                                  });
                                },
                              )
                            : Container(),
                        hintText: "검색",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    )),
                focusNode.hasFocus
                    ? Expanded(
                        child: TextButton(
                        child: Text('취소'),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                            _searchText = '';
                            focusNode.unfocus();
                          });
                        },
                      ))
                    : Expanded(flex: 0, child: Container())
              ],
            ),
          ),
          _buildBody(context)
        ],
      ),
    );
  }
}
