import 'package:clonenetflix/screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clonenetflix/model/model_movie.dart';

class LikeScreen extends StatefulWidget {
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  //firebase에서 데이터를 가져옴
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('movie')
          .where('like', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  //_buildBody()에서 가져온 데이터를 필터링
  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    return Expanded(
        child: GridView.count(
            crossAxisCount: 3, // 한줄에 3칸
            childAspectRatio: 1 / 1.5, //비율
            padding: EdgeInsets.all(3),
            children: snapshot
                .map((data) => _buildListItem(context, data))
                .toList()));
  }

  //GridView에 들어갈 InkWell로 그리고 그 누를때 마다 디테일 뷰를 띄우도록 함.
  Widget _buildListItem(BuildContext contextm, DocumentSnapshot data) {
    final movie = Movie.fromSnapshot(data);
    return InkWell(
      child: Image.network(movie.poster),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<Null>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return DetailScreen(movie: movie);
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 57, 20, 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'images/bbongflix_logo.png',
                fit: BoxFit.contain,
                height: 25,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  '내가 찜한 콘텐츠',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        _buildBody(context)
      ],
    ));
  }
}
