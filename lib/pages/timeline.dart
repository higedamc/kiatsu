import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listitem = [
      '低気圧つらすぎぴえん会社やめるニートになるもう誰か養って誰でもいいからもうここまで来たら。嫌なんだよ地元に帰って深夜にドンキに集まるクソガイジヤンキーの連れになってジャージにキティサンでハイエースゴールインは死んでもむりだからぁぁぁぁ👠',
      '気圧もそうだが雨も辛いね、そうです。今日は部長の代わりにとらやの羊羹で謝罪クエストがあるんです。え？私は受注したつもり無いですよ？でも社会人というのは不思議なものです🥺',
      '今日はあっちこっち炎上してるけども、季節の変わり目と低気圧のせいだろうから一回寝ろ。あと、そういう時期はヤベエ奴ほどヤバさが天元突破して活発になっちゃうから相手すんな。まじでうまいもん食ってクソして寝ろ。 https://twitter.com/ayuneo/status/1303746094740811776',
      '低気圧即死我即死即死即死即死即死即死他民加油加油加油加油🤮🤮🤮🤮',
      '低気圧つらいぴえんしょんしょん。。低気圧つらいぴえんしょんしょん。。低気圧つらいぴえんしょんしょん。。🥺🥺🥺',
    ];
    return Scaffold(
        appBar: NeumorphicAppBar(
          title: Text('timeline'),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: GestureDetector(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                elevation: 10,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(2.0),
                  child: Column(children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.cloud_circle,
                        size: 40,
                        color: Colors.black,
                      ),
                      title: Text(listitem[index].toString(),
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black)),
                    ),
                  ]),
                ),
              ),
            ));
          },
          itemCount: listitem.length,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black26,
          onPressed: () {},
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Hi:-)"),
                    );
                  });
            },
          ),
        ));
  }
}
