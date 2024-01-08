<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<% 

// 以降の配列はすべて[scene][0またはroute(選択したもの)]が入る。

// 各シーンの選択画面のテキスト。[シーン番号][0]が状況説明、[][1]以降が各選択肢。
String[][] selectText = {
	{"このストーリーは私がプログラミングを学ぶ過程で遭遇した出来事を描いたものです。\n"
			+ "元気値が0にならないようにしながら、知識値100を目指しましょう。"
    		, "start"
    		, "exit"},
	{"リファクタリングではなく置換を使って変数名を変更してしまった。"
    		, "似た名前の変数名はないし大丈夫だろう。"
    		, "念のためリファクタリングでやり直す。"},
	{"パソコン画面と数時間に渡り睨み合っている。\n"
    		+ "一向に解決の糸口がつかめない。"
    		, "粘って頑張る。"
    		, "諦めて帰る。"},
    {"エラーメッセージが表示された。"
    		, "エラーを翻訳する。"
    		, "ソースコードを見直す。"},
    {"ずっと座って作業していると体が痛くなってきた。"
    		, "pcスタンドやスタンディングデスクの購入を検討する。"
    		, "階段の段差を利用したり、本を積んで高さを調整する。"
    		, "諦めて座る"},
    {"他者のソースコードを手直しすることになった。"
    		, "修正点を確認する"
    		, "ゼロから作り直す"},
    {"次のソースコードの問題点が発見できない。\n"
    		+ "int numberOne0bject = 1;"
    		, "「スペース」の部分を確認してみる。"
    		, "「numberOne0bject」の部分を確認してみる。"
    		, "「1」の部分を確認してみる。"},
    {"作業が煮詰まってきて、頭がうまく働かない。"
    		, "独り言を口ずさむ。"
    		, "デスクに突っ伏す。"
    		, "今なら悟りを開けそうだ。"},
    {"いよいよ学習も大詰め。\n"
    		+ "集大成として就職に向けてポートフォリオを作ろう。"
    		, "学んだ知識で何を作ろうか。\nどこまでできるか楽しみだ。"
    		, "何をすればいいかわからず、デスクの上の整理に力を注いだ。"}
};

// 各シーンの結果画面のテキスト。[シーン番号][0]をルート1、[][1]以降各ルートが続く。
String[][] resultText = {
	{"「技術力のある人間になりたい！」\n"
			+ "そう考えた私はプログラミングを学ぶことにした。\n"
			+ "意気込みを新たに職業訓練校web.javaプログラミング科に通い始める。"
			,""},
	{"変数entを置換したらクラスStatementまで置換されていた。\n後々苦労した。"
    		, "何事もなくスムーズに作業できた。"},
	{"思うように頭が回らず結局解決できなかった。"
    		, "自宅でシャワーを浴びていると、突如頭に閃きが走った。\n"
    		+ "そうか！あの部分はああすれば良かったんだ！\n"
    		+ "問題はいつも唐突に解決する。"},
    {"翻訳したら、ほとんど英語で帰ってきて結局読めない。\n"
    		+ "しかし色々調べることでデバックの技術は向上した。"
    		, "一時間後、「;」のつけ忘れだと気付く。"},
    {"思いのほか高価なので二の足を踏む。\n"
    		+ "なんでも寝ころびながら操作できるらしい。"
    		,"快適な作業環境を手に入れた。しかし家族には怒られた。" 
    		, "腰が痛いが、学習は進んだ"},
    {"自分のものとは違うコーディングが多く、苦戦する。\n"
    		+ "いっそのこと一から作り直した方が速そうだ。"
    		, "新たな学びは少なかったがスムーズに進んだ。"},
    {"全角がまぎれているかと思ったが、そんなことはなかった。\n"
    		+ "結局何が原因なのかわからない。"
    		, "よく見ると「O(オー)」だと思っていたものが「0(ゼロ)」だった。\n"
    		+ "こんなものわかるわけない。"
    		, "全角の「1」かと思ったが、そんなことはなかった。\n"
    		+ "結局何が原因なのかわからない。"},
    {"独り言で自分を客観視できた。どうにも同じ言葉を繰り返してしまっている。\n"
    		+ "しかしその様子を見て助っ人が現れた。\n助けてもらうのも時には大切。"
    		, "少し休んだら、集中力が戻った。\nおかげで作業が進んだ。"
    		, "時々そんなことを考えてしまったりする。"},
    {"デスクは汚いがアプリケーションはそこそこきれいに完成した。\n"
    		+"バグやエラー、色々苦労したが、そのおかげで成長できた。\n"
    		+"何度も何度も少しずつ改良していく、それがプログラミングなのだろう"
    		, "バグだらけのアプリケーションが完成した。\n"
    		+ "自分でもなぜ動いているのかよくわからない。"}
};

// 選択結果による元気の増減値。resultTextと同様に0をルート1。以降が続く。
int[][] energyUpDown = {
    {100,0},
    {-25,0},
    {-25,10},
    {-15,-25},
    {0,-15,-25},
    {-25,-15},
    {-5,-20,-5},
    {-15,-5,0},
    {0,-100}
};

// 選択結果による知識の増加値。resultTextと同様に0をルート1。以降が続く。
int[][] informationUpDown = {
	{0,0},
    {20,0},
    {15,20},
    {20,15},
    {0,15,25},
    {20,15},
    {0,15,0},
    {20,20,0},
    {25,0}
};

// 各シーンの背景画像。selectTextと連動する。
String backPic[][] = {
    {"start", "0-1", ""},
    {"main", "1-1", "1-2"},
    {"main", "2-1", "2-2"},
    {"main", "3-1", "3-2"},
    {"main", "4-1", "4-2", "4-3"},
    {"main", "5-1", "5-2"},
    {"main", "6-1.3", "6-2", "6-1.3"},
    {"main", "7-1", "7-2", "7-3"},
    {"main", "8-1", "8-2"}
};

// ストーリー進行上の例外エラーメッセージを受け取る。
String message = null;
if(request.getParameter("message")!=null){
	message = request.getParameter("message");
}

// 各種パラメータの取得と例外処理。
int scene = 0; //シーン番号(ルート選択画面と選択結果画面のセット番号)
int route = 0; //ルート番号
int energy = 100; // 元気値
int information = 0; // 知識値
try{
	// パラメーターがないのはシーン0のみ
	if(request.getParameter("scene")!=null
			&& request.getParameter("route")!=null
			&& request.getParameter("energy")!=null
			&& request.getParameter("information")!=null){
		scene = Integer.parseInt(request.getParameter("scene"));
		route = Integer.parseInt(request.getParameter("route"));
		energy = Integer.parseInt(request.getParameter("energy"));
		// 元気値と知識値の上限(100)設定
		if(energy>100){
			energy = 100;
		}
		information = Integer.parseInt(request.getParameter("information"));
		if(information>100){
			information = 100;
		}
		// 不正なパラメータであれば例外をthrowする。ただし最後のシーンのみ除外。
		if(scene!=selectText.length){
			if(information<0
					|| scene<0
					|| route<0
					|| scene>selectText.length
					|| route>=selectText[scene].length){
				throw new Exception();
			}
		}
	}
}catch(Exception e){
	// 0を代入することでリダイレクト前の例外を回避する。
	e.printStackTrace();
	scene = 0;
	route = 0;
	String errorMessage = "ストーリー進行に何らかのエラーが発生したため、リスタートしました。";
	message = URLEncoder.encode(errorMessage, "UTF-8");
	response.sendRedirect("/novelGame/novelGame.jsp?message="+message);
}

// スタート画面でexitを選択した場合の処理。
if(scene==0 && route==2){
	response.sendRedirect("/novelGame/novelGame.jsp"); //正式なリダイレクト先は未定。
}
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet" href="novelGame.css">
<title>ノベルゲーム</title>
</head>
<body>
<!-- 元気値が尽きた場合はGameOver -->
<% if(energy<=0){ %>
	<div class="gameOver">
		<img src="images/gameOver.jpg" alt="背景画像">
		<div class="text">
			<p class="upDoun">元気が0になった。</p>
			<p>GameOver</p>
			<a href="novelGame.jsp">コンティニュー</a>
		</div>
	</div>
	
<!-- 最終シーン後にクリアメッセージを表示 -->
<% }else if(scene==selectText.length){ %>
	<div class="gameClear">
		<img src="images/gameClear.jpg" alt="背景画像">
		<div class="text">
			<p>GameClear</p>
			<a href="novelGame.jsp">初めからやり直す</a>
		</div>
	</div>

<% }else{ %>
	<div class="setting">
		<!-- エラーメッセージがあれば表示 -->
		<% if(message!=null){ %>
			<p><%= message %></p>
		<% } %>
		<h1>シーン <%= scene %></h1>
		<!-- 現状の元気値と知識値 -->
		<B>元気値：<%= energy %>　知識値：<%= information %></B>
	</div>
	
	<!-- ルート番号が0以外ならばルート選択済みなので、結果画面を表示 -->
	<% if(route>0){ %>
		<div class="route">
			<img src="images/<%= backPic[scene][route] %>.jpg" alt="背景画像">
			<div class="text">
				<!-- テキストに含まれる「\n」をhtmlタグの「br」に変換する -->
				<p><%= resultText[scene][route-1].replace("\n", "<br>") %></p>
				<p class="upDoun">
					<!-- 元気の増減により出力文を分ける -->
					<% if(energyUpDown[scene][route-1]>0){ %>
						元気を<%= energyUpDown[scene][route-1] %>取り戻した。
					<% }else{ %>
						元気を<%= -(energyUpDown[scene][route-1]) %>費やした。
					<% } %>
					知識が<%= informationUpDown[scene][route-1] %> 身についた。
				</p>
				<!-- 次のシーンへ -->
				<a href="novelGame.jsp?scene=<%= scene+1 %>
						&route=0
						&energy=<%= energy+energyUpDown[scene][route-1] %>
						&information=<%= information+informationUpDown[scene][route-1] %>">
						一日が終わる</a>
			</div>
		</div>
	<!-- ルート選択画面を表示する -->
	<% }else{ %>
		<div class="select">
			<img src="images/<%= backPic[scene][0] %>.jpg" alt="背景画像">
			<div class="text">
				<p><%= selectText[scene][0].replace("\n", "<br>") %></p>
				<!-- 最後のシーンなら -->
				<% if(selectText.length==scene+1){ %>
					<!-- 最後のシーンでは知識値が95以上であればルート1が選べる -->
					<% if(information>95){ %>
						<a href="novelGame.jsp?scene=<%= scene %>
								&route=1
								&energy=<%= energy %>
								&information=<%= information %>">
								<%= selectText[scene][1].replace("\n", "<br>") %></a><br>
					<% } %>
					<a href="novelGame.jsp?scene=<%= scene %>
							&route=2
							&energy=<%= energy %>
							&information=<%= information %>">
							<%= selectText[scene][2].replace("\n", "<br>") %></a>
				<% }else{ %>
					<!--ルートの数だけ表示を増やす。-->
					<% for(int i=1; selectText[scene].length>i;i++){ %>
						<a href="novelGame.jsp?scene=<%= scene %>
								&route=<%= i %>
								&energy=<%= energy %>
								&information=<%= information %>">
								<%= selectText[scene][i].replace("\n", "<br>") %></a><br>
					<% } %>
				<% } %>
			</div>
		</div>
	<% } %>
<% } %>
</body>
</html>