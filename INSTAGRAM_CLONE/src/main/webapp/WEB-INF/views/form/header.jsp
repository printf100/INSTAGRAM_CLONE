<%@ page import="org.apache.catalina.SessionListener"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
%>
<%
	response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<!-- bootstrap -->
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
   <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
<!-- end bootstrap --!>

<!-- START :: css -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link href="/resources/css/master.css" rel="stylesheet" type="text/css">
	
	<style type="text/css">
	
	</style>
<!-- END :: css -->

<!-- START :: set JSTL variable -->
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
	<c:set var="sessionLoginMember" value="${sessionScope.user}"></c:set>
	<c:set var="sessionLoginMemberProfile" value="${sessionScope.profile}"></c:set>
<!-- END :: set JSTL variable -->

<!-- START :: JAVASCRIPT -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript">
	
	</script>
<!-- END :: JAVASCRIPT -->

</head>
<body>
	<header>
		<nav class="navbar bg-white border">
			<div class="d-flex justify-content-center mx-auto">
				<!-- brand icon -->
				<a class="navbar-brand mr-5" href="/feed/feed"><h3>instagram</h3></a>				
	
				<!-- 검색창 -->
				<form id="headerSearch" class="form-inline mx-5" action="/feed/feed" method="post">
					<div class="input-group">
						<div class="input-group-prepend">	
							<span id="headerSearchSubmitButton" class="input-group-text bg-light"><i class="fas fa-search" onclick=";"></i></span>						
						</div>
						
						<input class="form-control bg-light" type="text" name="search" value="${search}" placeholder="검색">
						
						<div class="input-group-append">	
							<span id="headerSearchSubmitButton" class="input-group-text bg-light"><i class="fas fa-times-circle" onclick=";"></i></span>						
						</div>
					</div>
				</form>				
				
				<!-- nav list -->						
				<ul class="navbar-nav list-group-horizontal ml-5">

					<li class="nav-item">
						<h4 class="mx-2"><a class="nav-link" href="/feed/"><i class="fas fa-home"></i></a></h4>
					</li>
					<li class="nav-item">
						<h4 class="mx-2"><a class="nav-link" href="/dm/"><i class="far fa-paper-plane"></i></a></h4>
					</li>
					<li class="nav-item">
						<h4 class="mx-2"><a class="nav-link" href="#"><i class="far fa-compass"></i></a></h4>
					</li>
					<li class="nav-item">
						<h4 class="mx-2"><a class="nav-link" href="#"><i class="far fa-heart"></i></a></h4>
					</li>
					<li class="nav-item">
						<h4 class="mx-2">
							<a class="nav-link" href="/member/profile">
							<c:choose>
								<c:when test="${not empty sessionLoginMemberProfile.member_img_server_name}">
									<div class="rounded-circle border border-dark  w-26 h-26 overflow-hidden">										
										<img 
											id="header_profile_image" 
											class="w-26 h-26 bg-white cursor-pointer vertical-align-baseline"
											src="/resources/images/profileupload/${sessionLoginMemberProfile.member_img_server_name }"
										>
									</div>
								</c:when>
								<c:otherwise>
									<i class="far fa-user-circle"></i>
								</c:otherwise>
							</c:choose>
						
							</a>
						</h4>
					</li>
					<li class="nav-item">
						<h4 class="mx-2"><a class="nav-link" href="/ssoclient/logout"><i class="fas fa-sign-out-alt"></i></a></h4>
					</li>
			    </ul>
			</div>
		</nav>

	</header>	
</body>

<!-- START :: 헤더폼에서 소켓을 열어 프로그램 전체에서 소켓통신이 열린 상태를 유지한다. -->
	<script type="text/javascript">
		
		// 소켓 객체를 담을 변수
		var ws; 
		
		function openSocket(){
	        ws = new WebSocket("ws://localhost:${sessionScope.SERVER_PORT}/echo");
		}
		$(function(){
	        if(ws !== undefined && ws.readyState !== WebSocket.CLOSED){
	            /* writeResponse("WebSocket is already opened.") */
	            return
	        }
	        // 웹소켓 객체 생성
	        openSocket();
	        
	        // 웹소켓 열림
	        ws.onopen=function(event){	    				        	
	            if(event.data === undefined) {
	            	return
	            } else {	            	
		            alert("소켓 연결")
	            }	            
	        };
	        
	        // 소켓으로부터 메시지 도착 시 (메시지의 attribute 이름에 따라 이벤트를 구분)
	        ws.onmessage=function(event){
	        	
	            var data = JSON.parse(event.data);
            	
	            if (data.enter != undefined) { // 다른 접속자가 채팅창에 접속했음을 알림	
		            notifyUnreadChange(data.enter);          
	            } else if (data.chat != undefined){ // 접속자의 메시지가 도착함 
		            writeResponse(event.data)	
					findMyChatRoomList() // 채팅방 리스트도 최신화
	            }
	            
	        };
	        
	        // 소켓 통신 종료 시
	        ws.onclose=function(event){
	            /* alert("소켓 연결종료") */
	            console.log("소켓 연결종료")
	        }
		})
	</script>
<!-- END :: 헤더폼에서 소켓을 열어 프로그램 전체에서 소켓통신이 열린 상태를 유지한다. -->


</html>