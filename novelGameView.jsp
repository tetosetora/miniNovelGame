<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder, novelGame_model.NovelGameData" %>
<% 

NovelGameData data = (NovelGameData) request.getAttribute("data");

// モデルからデータを取得
int scene = data.getScene();
int route = data.getRoute();
int energy = data.getEnergy();
int information = data.getInformation();
int sceneCount = data.getSceneCount();
int onesceneRouteCount = data.getOnesceneRouteCount(scene);
String backPic = data.getBackPic(scene, route);
// 選択結果画面の際に必要なデータを取得
int energyUpDown = 0;
int informationUpDown = 0;
String resultText = null;
if(route>0){
	energyUpDown = data.getEnergyUpDown(scene, route);
	informationUpDown = data.getInformationUpDown(scene, route);
	resultText = data.getResultText(scene, route);
}

// ストーリー進行上の例外エラーメッセージを受け取る。
String errorMessage = null;
if(request.getAttribute("errorMessage")!=null){
	errorMessage = (String)request.getAttribute("errorMessage");
}

// スタート画面でexitを選択した場合のゲームのリンクのあったページにリダイレクト。。
if(scene==0 && route==2){
	response.sendRedirect("http://54.206.77.246:8080/profile/introductionNG.html");
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
			<a href="control">コンティニュー</a>
		</div>
	</div>
	
<!-- 最終シーン後にクリアメッセージを表示 -->
<% }else if(scene==sceneCount-1){ %>
	<div class="gameClear">
		<img src="images/gameClear.jpg" alt="背景画像">
		<div class="text">
			<p>GameClear</p>
			<a href="control">初めからやり直す</a>
		</div>
	</div>

<% }else{ %>
	<div class="setting">
		<!-- エラーメッセージがあれば表示 -->
		<% if(errorMessage!=null){ %>
			<p><%= errorMessage %></p>
		<% } %>
		<h1>シーン <%= scene %></h1>
		<!-- 現状の元気値と知識値 -->
		<p class="param">元気値：<%= energy %>　知識値：<%= information %></p>
	</div>
	
	<!-- ルート番号が0以外ならばルート選択済みなので、結果画面を表示 -->
	<% if(route>0){ %>
		<div class="route">
			<img src="images/<%= backPic %>.jpg" alt="背景画像">
			<div class="text">
				<!-- テキストに含まれる「\n」をhtmlタグの「br」に変換する -->
				<p><%= resultText.replace("\n", "<br>") %></p>
				<p class="upDoun">
					<!-- 元気値により出力文を分ける -->
					<% if(energyUpDown>0){ %>
						元気を<%= energyUpDown %>回復した。
					<% }else if(energyUpDown<0){ %>
						元気を<%= -(energyUpDown) %>消費した。
					<% } %>
					
					<% if(informationUpDown>0){ %>
						知識が<%= informationUpDown %>増えた。
					<% } %>
				</p>
				<!-- 次のシーンへ -->
				<form action="control" method="post">
					<input type="hidden" name="scene" value="<%= scene+1 %>">
					<input type="hidden" name="route" value="0">
					<input type="hidden" name="energy" value="<%= energy+energyUpDown %>">
					<input type="hidden" name="information" value="<%= information+informationUpDown %>">
					<div><input class="button" type="submit" value="一日が終わる"></div>
				</form>
			</div>
		</div>
	<!-- ルート選択画面を表示する -->
	<% }else{ %>
		<div class="select">
			<img src="images/<%= backPic %>.jpg" alt="背景画像">
			<div class="text">
				<p><%= data.getSelectText(scene, route).replace("\n", "<br>") %></p>
				<!-- 最後のシーンなら -->
				<% if(scene==sceneCount-2){ %>
					<!-- 最後のシーンでは知識値が90以上であればルート1が選べる -->
					<% if(information>=90){ %>
						<form action="control" method="post">
							<input type="hidden" name="scene" value="<%= scene %>">
							<input type="hidden" name="route" value="1">
							<input type="hidden" name="energy" value="<%= energy %>">
							<input type="hidden" name="information" value="<%= information %>">
							<div><input class="button" type="submit" value="<%= data.getSelectText(scene, 1) %>"></div>
						</form>
					<% } %>
						<form action="control" method="post">
							<input type="hidden" name="scene" value="<%= scene %>">
							<input type="hidden" name="route" value="2">
							<input type="hidden" name="energy" value="<%= energy %>">
							<input type="hidden" name="information" value="<%= information %>">
							<div><input class="button" type="submit" value="<%= data.getSelectText(scene, 2) %>"></div>
						</form>
				<% }else{ %>
					<!--ルートの数だけ表示を増やす。-->
					<% for(int i=1; onesceneRouteCount>i;i++){ %>
						<form action="control" method="post">
							<input type="hidden" name="scene" value="<%= scene %>">
							<input type="hidden" name="route" value="<%= i %>">
							<input type="hidden" name="energy" value="<%= energy %>">
							<input type="hidden" name="information" value="<%= information %>">
							<div><input class="button" type="submit" value="<%= data.getSelectText(scene, i) %>"></div>
						</form>
					<% } %>
				<% } %>
			</div>
		</div>
	<% } %>
<% } %>
</body>
</html>