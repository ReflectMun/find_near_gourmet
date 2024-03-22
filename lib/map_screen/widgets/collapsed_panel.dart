import 'package:flutter/material.dart';

// スライディングパネルが下がった際に表示するウィジェット
class CollapsedPanel extends StatelessWidget {
  const CollapsedPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45)
        ),
        color: Color(0xFFFDFDFD),
      ),
      margin: const EdgeInsets.only(
          top: 10,
          left: 0,
          right: 0,
          bottom: 0 // 底に埋め込まれているような形を実装するため、ボトムのマージン値を0に設定
      ),
      child: Column(
        children: [
          // スワイプができる要素であることを示す手元アイコン
          const Icon(Icons.dehaze_outlined),
          // スワイプができる要素であることを示す手元アイコン

          // 検索条件の設定ができる領域であることを示すタイトル
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 27.5),
            child: const Center(
              child: Text(
                "検索条件",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32
                ),
              ),
            ),
          ),
          // 検索条件の設定ができる領域であることを示すタイトル

        ],
      ),
    );
  }
}