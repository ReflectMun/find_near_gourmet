// 検索半径のタイトル
const Center(
child = Text(
"検索半径",
style: TextStyle(
fontWeight: FontWeight.w400,
fontSize: 20
),
),
),
// 検索半径のタイトル、おわり

// 検索半径の選択ボタンリスト
Container(
height = 65,
child = ListView.builder(
scrollDirection: Axis.horizontal,
itemBuilder: (ctx, index) {
return Container(
decoration: const BoxDecoration(
color: Color(0xFFE9E9E9),
borderRadius: BorderRadius.all(Radius.circular(20))
),
padding: const EdgeInsets.all(10),
margin: const EdgeInsets.all(10),
child: Text(
_ranges[index],
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.w400
),
),
);
},
itemCount: _ranges.length
),
),
// 検索半径の選択ボタンリスト、おわり