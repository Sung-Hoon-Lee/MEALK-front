import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatefulWidget {
  @override
  _TermsOfServiceScreenState createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  List<String> termsTitles = [
    '만 14세 이상입니다',
    '밀크 이용약관',
    '개인정보 수집 및 이용 동의',
    '전자금융거래 이용약관',
    // '위치기반서비스 이용약관',
    // '혜택 및 마케팅 정보 수신 동의',
  ];
  List<String> termsLinks = [
    '', // 만 14세 이상 동의는 내용 없음
    'https://www.notion.so/41994aaf254d481b9ae81f5d474d5c4f?pvs=4',
    'https://www.notion.so/13c73a659b32455293714a5772299d96?pvs=4',
    'https://www.notion.so/f8eb221ceabf4e3987618429b03bf54c?pvs=4',
    // 약관 메인 페이지 링크
    // 'https://orange-dive-744.notion.site/ce6b3fc7534c4d88b08865e25e339978?pvs=4',
  ];
  // 약관 수 늘릴 시에는 termsTitles와 termsLinks를 추가한 후 아래 List.generate 숫자 변경
  List<bool> _isChecked = List.generate(4, (index) => false);
  List<bool> _isExpanded = List.generate(4, (index) => false);


  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      _isChecked[index] = value!;
      if (_isChecked.every((element) => element)) {
        _isAllAgreed = true;
      } else if (_isAllAgreed) {
        _isAllAgreed = false;
      }
    });
  }

  void _toggleAll(bool? value) {
    setState(() {
      _isAllAgreed = value!;
      for (int i = 0; i < _isChecked.length; i++) {
        _isChecked[i] = value;
      }
    });
  }

  bool _isAllAgreed = false;

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw '링크 열기 실패! $url';
    }
  }

  Color backgroundColor = const Color.fromRGBO(196, 232, 181, 0.9);
  Color buttonColor = const Color.fromRGBO(94, 130, 87, 1.0);
  TextStyle titleFontStyle = const TextStyle(fontSize: 32, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle stringFontStyle = const TextStyle(fontSize: 16, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle buttonFontStyle = const TextStyle(fontSize: 26, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Colors.white);
  TextStyle termsTitlesFontStyle = const TextStyle(fontSize: 20, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));
  TextStyle termsContentsFontStyle = const TextStyle(fontSize: 16, fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, color: Color.fromRGBO(94, 130, 87, 1.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('밀크 서비스 이용 약관', style: TextStyle(fontFamily: 'NotoSansKR', fontWeight: FontWeight.w900, fontSize: 24),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(94, 130, 87, 1.0),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CheckboxListTile(
              checkColor: Colors.white,
              activeColor: buttonColor,
              title: Text('모든 약관에 동의합니다.', style: stringFontStyle,),
              value: _isAllAgreed,
              onChanged: _toggleAll,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: termsTitles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10), // 각 항목 사이의 간격
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), // borderRadius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3), // 그림자의 위치 변경
                        ),
                      ],
                    ),
                    child: _buildPanel(index),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), //테두리
                ),
                onPressed: _isChecked.take(4).every((checked) => checked) ? () {
                  Navigator.pushNamed(context, 'signup');
                } : null,
                child: Text(' 회원가입하기 ', style: buttonFontStyle,),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(int index) {
    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _isExpanded[index] = !isExpanded;
        });
      },
      children: [
        // 약관 title
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              child: ListTile(
                // 약관 동의 4개 초과는 선택 약관으로 처리
                title: Text('${termsTitles[index]}${index >= 4 ? ' (선택)' : ''}', style: termsTitlesFontStyle,),
                trailing: Checkbox(
                  checkColor: Colors.white,
                  activeColor: buttonColor,
                  value: _isChecked[index],
                  onChanged: (bool? value) {
                    _toggleCheckbox(index, value);
                  },
                ),
              ),
            );
          },
          // 약관 내용
          body: Container(
            padding: EdgeInsets.all(16.0),
            // child: Text('${termsContents[index]}'),
            child: index != 0
            ? Row(
              children: [
                IconButton(
                  icon: Icon(Icons.find_in_page),
                  color: buttonColor,
                  onPressed: () {
                    _launchUrl('${termsLinks[index]}');
                  },
                ),
                // Icon(Icons.find_in_page),
                TextButton(
                  onPressed: (){
                    _launchUrl('${termsLinks[index]}');
                  },
                  child: Text('${termsTitles[index]} 전문보기 (클릭)', style: termsContentsFontStyle,),
                ),
              ]
            )
            : Text(''),
          ),
          isExpanded: _isExpanded[index],
          canTapOnHeader: true, // 헤더를 탭하여 확장/접기
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }
}