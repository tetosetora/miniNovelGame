package novelGame_control;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import novelGame_model.NovelGameData;

@WebServlet("/control")
public class NovelGameControl extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		NovelGameData data = new NovelGameData();
		
		try{
			int scene = 0;
			int route = 0;
			int energy = 100;
			int information = 0;
			
			if(request.getParameter("scene")!=null
					&& request.getParameter("route")!=null
					&& request.getParameter("energy")!=null
					&& request.getParameter("information")!=null){
				// 各種パラメータの取得。
				scene = Integer.parseInt(request.getParameter("scene"));
				route = Integer.parseInt(request.getParameter("route"));
				energy = Integer.parseInt(request.getParameter("energy"));
				information = Integer.parseInt(request.getParameter("information"));

				// 元気値と知識値の上限(100)設定
				if(energy>100){
					energy = 100;
				}
				if(information>100){
					information = 100;
				}
				
				// 不正なパラメータであれば例外をthrowする。
				if(information<0
						|| scene<0
						|| route<0
						|| scene>data.getSceneCount()
						|| route>data.getOnesceneRouteCount(scene)){
					throw new Exception();
				}
			}
			
			data.setScene(scene);
			data.setRoute(route);
			data.setEnergy(energy);
			data.setInformation(information);
			
		}catch(Exception e){
			String errorMessage = "ストーリー進行に何らかのエラーが発生したため、リスタートしました。";
			request.setAttribute("errorMessage", errorMessage);
			data.setScene(0);
			data.setRoute(0);
			data.setEnergy(100);
			data.setInformation(0);
		}
		
	    // ビューにフォワード
		request.setAttribute("data", data);
	    RequestDispatcher dispatcher = request.getRequestDispatcher("novelGameView.jsp");
	    dispatcher.forward(request, response);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
