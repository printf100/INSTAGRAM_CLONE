<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- START :: HEADER FORM -->
	<%@ include file="../form/header.jsp"%>
<!-- END :: HEADER FORM -->

<!-- START :: css -->
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" type="text/css" rel="stylesheet"/>
	<link href="/resources/css/dm.css" rel="stylesheet" type="text/css">
	<style type="text/css">
		#mask{
			position:absolute; 
			z-index:9000; 
			background-color:#000000; 
			left:0; 
			top:0;
		}
		#searchFriendsForm{
			position:absolute; 
			z-index:9999; 
			top:30%; 
			left:30%; 
			width: 40%; 
			height:40%; 
			background-color: white;
		}
	</style>
<!-- END :: css -->
</head>

<body>
	
	<section class="container w-75 h-700">		
		<div class="container">			
			<div class="messaging">
				<div class="inbox_msg">
				
					<div class="inbox_people">		
						<div class="headind_srch">
							<div class="recent_heading">
								<h4>Direct</h4>
							</div>
							<div class="srch_bar">
								<span class="h-100 py-auto float-right"><i class="far fa-edit" onclick="searchFriends();"></i></span>				
							</div>
						</div>
					
						<!-- START :: 채팅방 리스트 -->
			            <div id="chatRoomList" class="inbox_chat">			  
			            </div>
			            <!-- END :: 채팅방 리스트 -->						
					</div>		
					
					<!-- START :: 채팅 메세지 리스트 -->
		          	<div class="mesgs">
		          	
		          		<!-- START :: 채팅방 입장전에 나오는 폼 -->
		          		<div id="before_enter_chatroom_form">
		          			<div class="rounded-circle border border-dark w-150 h-150"><i class="far fa-paper-plane"></i></div>
		          			<h1>내 메시지</h1>
		          			<p>친구나 그룹에 비공개 사진과 메시지를 보내보세요.</p>
		          			<button></button>
		          		</div>
		          		<!-- END :: 채팅방 입장전에 나오는 폼 -->
		          	
		          		<!-- START :: 채팅방 입장시 나오는 폼 -->
		            	<div id="messages" class="msg_history scroll_fix_bottom">               
		            	</div>
		             
		            	<div class="type_msg">
			              	<div class="input_msg_write">
			              		<input type="hidden" name="room_code">				
			                	<input type="text" class="write_msg" id="messageinput" placeholder="메시지 입력..." />

			                	<button class="msg_send_btn" id="sendMessage" type="button" onclick="send();"><i class="fa fa-paper-plane-o" aria-hidden="true"></i></button>
			              	</div>
		            	</div>
		          		<!-- END :: 채팅방 입장시 나오는 폼 -->
		          		
		          	</div>
		          	<!-- END :: 채팅 메세지 리스트 -->			
				</div>			
			</div>		
		</div>
		
		
	</section>
	
	
	<div id="mask">
		<div id="searchFriendsForm" class="card rounded-lg">
			<div class="border text-center">
				<span class="float-left"><i class="fas fa-times" onclick="hideSearchFriendsForm();"></i></span>
				<strong>새로운 메시지</strong>
				<span class="float-right"><a onclick="makeChatRoom();">다음</a></span>
			</div>
			
			<div class="d-flex align-items-center border h-25 overflow-scroll">
				<strong id="cathMemberList" class="d-flex">받는 사람 : </strong>
				<input type="text" name="searchFriends" autocapitalize="none" placeholder="검색..." style="border:none;border-right:0px; border-top:0px; boder-left:0px; boder-bottom:0px;">
			</div>
			
			<div id="searchedMemberList" class="border h-75 overflow-scroll">
				
			</div>		
		</div>
	</div>
	
</body>
<!-- START :: 소켓으로부터 도착한 메시지 핸들링 -->
	<script type="text/javascript">
		$(function(){
	        // 소켓으로부터 메시지 도착 시 (메시지의 attribute 이름에 따라 이벤트를 구분)
	        ws.onmessage=function(event){
	        	
	            var data = JSON.parse(event.data);
            	
	            if (data.enter != undefined) { // 다른 접속자가 채팅창에 접속했음을 알림	
		            notifyUnreadChange(data.enter);          
	            } else if (data.chat != undefined){ // 접속자의 메시지가 도착함 
	            	// 해당 채팅방을 열어놓은 상태라면 메시지 출력
	            	if(data.room_code == $("input[name='room_code']").val()){
		            	writeChatMessage(data)
	            	}
					findMyChatRoomList() // 채팅방 리스트 최신화
	            }
	            
	        };
		})
	</script>
<!-- END :: 소켓으로부터 도착한 메시지 핸들링 -->

<!-- START :: chat -->	
	<script type="text/javascript">		
		// send message
		$(function(){
			$("#messageinput").keyup(function(e){
				e.preventDefault();
				
				var messageinput = $("#messageinput").val();
				
				var code = e.keyCode ? e.keyCode : e.which;

				if(code == 13){// 엔터키
					
					if(e.shiftKey == true){// shift키 눌린 상태에서는 다음 라인으로
						
					} else {// 메세지전송
						sendChatMessage();
					}
				
					return false;
				}
			})
		})
		
		// 채팅방열기
		function openChatRoom(room_code, thisDiv){
			selectChatList(room_code);
			// 소켓에 방에 입장했음을 알리는 메시지를 보냄
			sendOutChatRoom();
			$("input[name='room_code']").val(room_code)
			sendEnterChatRoom();
			
			// 활성화된 채팅방에 active_chat class 추가
			var chat_list = $(".inbox_chat").children();
			chat_list.each(function(){
				$(this).removeClass("active_chat");
			})
			$(thisDiv).addClass("active_chat")			
		}
		
		function sendEnterChatRoom(){
	        ws.send("enter," 
	        		+ $("input[name='room_code']").val()
	        		);
		}
		function sendOutChatRoom(){
	        ws.send("out," 
	        		+ $("input[name='room_code']").val()
	        		);
		}
	    function sendChatMessage(){
	        ws.send("chat," 
	        		+ $("input[name='room_code']").val() + "," 
	        		+ $("#messageinput").val())
	        		;
			$("#messageinput").val("");
			findMyChatRoomList() // 채팅방 리스트 최신화
	    }
	    
	    // 소켓으로부터받은 채팅 메시지 뿌리기
	    function writeChatMessage(mdata){
			
			var chat_container = $("<div>");
			var img_container = $("<div>").attr({"class":"incoming_msg_img"});
			var msg_container = $("<div>");
			
			if(${sessionLoginMember.member_code} === mdata.member_code){
				chat_container.addClass("outgoing_msg");
				
				msg_container
					.append($("<div>").attr({"class":"sent_msg"})
						.append($("<span>").text(mdata.chat_message_date))
						.append($("<p>").text(mdata.chat_message))
						.append($("<span>").attr({"class":"unread", "data-unreadlist":mdata.unread_member_code_list}))
					)
					
				chat_container.append(msg_container);
			} else {
				chat_container.addClass("incoming_msg")
				msg_container.addClass("received_msg")
				
				img_container
					.append($("<img>").attr({"src":"/resources/images/profileupload/" + mdata.member_profile_image_s_name}))
				
					
				msg_container
					.append($("<div>").attr({"class":"received_withd_msg"})
						.append($("<span>").text(mdata.chat_message_date))
						.append($("<p>").text(mdata.chat_message))
						.append($("<span>").attr({"class":"unread", "data-unreadlist":mdata.unread_member_code_list}))
						)
						
				chat_container.append(img_container).append(msg_container)
			}
			
			$("#messages").append(chat_container);
			setUnreadData();
			
			$('.scroll_fix_bottom').scrollTop($('.scroll_fix_bottom').prop('scrollHeight'));
		}

	    // 채팅리스트 전체에서 읽음표시 set
	    function setUnreadData(){
	    	var message = $("#messages").children();

	    	$.each(message, function(index, msg){
	    		var unread = $(this).find(".unread").attr("data-unreadlist");
	    		var unread_length;
	    		
	    		console.log(">>>" + unread);
	    		
				if(unread == ""){
					unread_length = '읽음'
				} else {
					unread_length = unread.split(',').length;
				}
				
	    		$(this).find(".unread").text(unread_length)	    		
	    	})
	    }
	    
	    
	    function notifyUnreadChange(reader){
	    	var message = $("#messages").children();
	    	
	    	console.log(reader + " 번 멤버 입장!")
	    	
	    	$.each(message, function(index, msg){
	    		var unread = $(this).find(".unread").attr("data-unreadlist");    		
	    		
	    		var unread_list = unread.split(',');
	    		
	    		for(var i=0; i<unread_list.length; i++){
	    			
	    			if(unread_list[i] == reader){		    			
	    				unread_list.splice(i, 1);	 // 접속한 참여자가 unread_ilst에 존재한다면 삭제   				
	    				
		    			$(this).find(".unread").attr("data-unreadlist", unread_list);
	    				break;
	    			}
	    		}
	    	})
	    	
	    	setUnreadData()	    	
	    }
	</script>
<!-- END :: chat -->
	
<!-- START :: 채팅만들기 폼 -->
	<script type="text/javascript">
		function searchFriends() {
		    //화면의 높이와 너비를 구합니다.
		    var maskHeight = $(document).height();
		    var maskWidth  = window.document.body.clientWidth;
		     
		    //화면에 출력할 마스크를 설정해줍니다.
		    var mask = $("#mask");
		    var searchFriendsForm = $("#searchFriendsForm");
		    
		    //마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채웁니다.
		    $('#mask').css({
		            'width' : maskWidth,
		            'height': maskHeight,
		            'opacity' :'0.6'
		    });
		    	  
		    //마스크 표시
		    $('#mask, #searchFriendsForm').show();
		}
		
		$(function(){
			$("#mask").hide();
			$("#searchFriendsForm").hide();
			
			$(document).on("click", "#mask", function(){
			    $('#mask, #searchFriendsForm').hide(); 
			})
			$(document).on("click", "#searchFriendsForm", function(){
				return false;
			})
		})
		function hideSearchFriendsForm(){
		    $('#mask, #searchFriendsForm').hide(); 
		}
	</script>
<!-- END :: 채팅만들기 폼 -->

<!-- START :: 회원 검색 자동 완성 -->
	<script type="text/javascript">
		$(function(){
			$("input[name='searchFriends']").autocomplete({
				source: function(request, response){
				    $.ajax({
				        type: "POST",
				        url: "/dm/nameSearchAutoComplete",
				        data: {
				        	my_member_code : '${sessionLoginMember.member_code}',
				        	id_name : request.term
				        },
				        datatType: "JSON",
		
				        success: function (data) {
				        	console.log(data)
					        response(
				        		$.map(data, function(item){
				        			return{
				        				label: item.member_id,
				        				value: item.member_id,
				        				code: item.member_code,
				        				name: item.member_name,
				        				image: item.member_profile_image_s_name
				        				
				        			}
				        		})	
				        	)
				        },
				        error: function () {
				           alert("통신 실패");
				        }
				     })
				},
				minLength : 1,
				focus : function(event, ui){
					$("input[name='searchFriends']").val(ui.item.value)
					return false;
				}
			}).autocomplete("instance")._renderItem = function(ul, item){
				
				console.log(item)
				
				var li_item = $("<div>").attr({
						"class":"d-flex align-items-center ml-2",
						"onclick":"addChatMember(" + item.code + ",'" + item.label +"')"
					});
				if(item.image != null){
					
				}else{
					
				}
				li_item.append($("<img>").attr({
									"class" : "rounded-circle m-1 w-40 h-40 bg-white vertical-align-baseline",
									"src" : '/resources/images/profileupload/' + item.image
								}))
								.append($("<span>").attr({"class":"id mx-1"}).text(item.label))
								.append($("<span>").attr({"class":"name mx-1"}).text(item.name))
								
				return $("<div>").append(li_item).appendTo($("#searchedMemberList"));
			}
		
		})
		
	</script>
<!-- END :: 회원 검색 자동 완성 -->
	
<!-- START :: 채팅방 생성 -->
	<script type="text/javascript">
		var jsonArray = new Array();
		var json = new Object()
		json.member_code = ${sessionLoginMember.member_code}			
		jsonArray.push(json)
		
		function addChatMember(code, member_id){
			
			for (var i = 0; i < jsonArray.length; i++){
				if(jsonArray[i]["member_code"] == code){
					jsonArray.splice(i, 1)
					return	
				}
			}
			
			var json = new Object()
			json.member_code = code			
			jsonArray.push(json)
			
			
			$("#cathMemberList").append($("<span>").attr({"class":"card bg-primary"}).text(member_id))
			$(this).attr({"style":"background-color: red;"})
			console.log($(this).children('.id').text())
		}
		
		function makeChatRoom(){
			console.log("makeChatRoom : " + JSON.stringify(jsonArray))
			
			$.ajax({
				type: "post",
				url: "/dm/makeChatRoom",
				data: JSON.stringify(jsonArray),
				contentType: "application/json",
				dataType: "json",
				
				success: function(msg){
					console.log(msg.insertedChatRoom);
					hideSearchFriendsForm();
					
					var data = new Array();
					data.push(msg.insertedChatRoom)
					fillChatRoomList(data);
				},
				
				error: function(){
					alert("통신실패");
				}
			})
		}
	</script>
<!-- END :: 채팅방 생성  -->

<!-- START :: 채팅방 리스트 불러오기 -->
	<script type="text/javascript">
		$(function(){
			findMyChatRoomList()
		})
		
		function findMyChatRoomList(){
			$.ajax({
				type: "post",
				url: "/dm/findMyChatRoomList",
				data: JSON.stringify({
					my_member_code : '${sessionLoginMember.member_code}'				
				}),
				contentType: "application/json",
				dataType: "json",
				
				success: function(data){
					console.log(data)
					$("#chatRoomList").empty();
					fillChatRoomList(data)
				},
				
				error: function(){
					alert("통신실패");
				}
			})
		}
	</script>
<!-- END :: 채팅방 리스트 불러오기 -->

<!-- START :: 채팅방 리스트 뿌리기 -->
	<script type="text/javascript">
		function fillChatRoomList(data){
			$.each(data, function(index, item){
				console.log(item)
				
				var chat_list = $("<div>").attr({"class":"chat_list", "data-roomcode":item.room_code, "onclick":"openChatRoom(" + item.room_code + ", this);"});
				var chat_people = $("<div>").attr({"class":"chat_people"});
				var chat_img = $("<div>").attr({"class":"chat_img d-flex"});
				var chat_ib = $("<div>").attr({"class":"chat_ib"});
				
				var recent_message_member_id;
				$.each(item.member_list, function(idx, member){		
					if(${sessionLoginMember.member_code} != member.member_code){
						chat_img
							.append($("<img>").attr({"class":"rounded-circle", "src":"/resources/images/profileupload/" + member.member_profile_image_s_name}))
					}
					
					if(item.member_code == member.member_code){
						recent_message_member_id = member.member_id; // 최신 메시지를 보낸 멤버의 아이디를 추출
					}
				})
				
				if(item.member_code != 0){
					chat_ib
						.append($("<h5>").text(recent_message_member_id))
						.append($("<p>").text(item.message)
								.append($("<span>").attr({"class":"chat_date float-right"}).text(getElapsedTime(item.message_date)))
								)
				}
					
				$("#chatRoomList").append(chat_list.append(chat_people.append(chat_img).append(chat_ib)));
			})
			
			// 활성화된 채팅방에 active_chat class 추가
			var chat_list = $(".inbox_chat").children();
			chat_list.each(function(){
				if($(this).attr("data-roomcode") == $("input[name='room_code']").val()){
					$(this).addClass("active_chat")
				}
			})	
		}
		
		function getElapsedTime(recent_date){
			var recent_year = recent_date.substr(0, 4);
			var recent_month = recent_date.substr(6, 2) - 1;
			var recent_day = recent_date.substr(10, 2);
			var recent_hour = recent_date.substr(14, 2);
			var recent_min = recent_date.substr(17, 2);

			var new_date = new Date();
			var old_date = new Date(recent_year, recent_month, recent_day, recent_hour, recent_min);
			
			var betweenDay = Math.floor((new_date.getTime() - old_date.getTime())/1000/60/60/24);
			var betweenHour = Math.floor((new_date.getTime() - old_date.getTime())/1000/60/60);
			var betweenMin = Math.floor((new_date.getTime() - old_date.getTime())/1000/60);
			
			return (betweenDay != 0) ? betweenDay+"일" : (betweenHour != 0) ? betweenHour+"시" : (betweenMin != 0) ? betweenMin+"분" : "방금";
		}
	</script>
<!-- END :: 채팅방 리스트 뿌리기 -->

<!-- START :: 채팅 리스트 가져오기 -->
	<script type="text/javascript">
		function selectChatList(room_code){
			$.ajax({
				type: "post",
				url: "/dm/selectChatList",
				data: JSON.stringify({
					room_code : room_code				
				}),
				contentType: "application/json",
				dataType: "json",
				
				success: function(data){
					fillChatList(data);
				},
				
				error: function(){
					alert("통신실패");
				}
			})
		}
	</script>
<!-- END :: 채팅 리스트 가져오기 -->

<!-- START :: 채팅 리스트 뿌리기-->
	<script type="text/javascript">
		function fillChatList(data){
			$("#messages").empty();
			
			$.each(data, function(index, item){
				console.log(item)

				var chat_container = $("<div>");
				var img_container = $("<div>").attr({"class":"incoming_msg_img"});
				var msg_container = $("<div>");
				
				$.each(item.member_list, function(idx, member){					
					
					if(item.member_code === member.member_code){
					
						if(${sessionLoginMember.member_code} === item.member_code){
							chat_container.addClass("outgoing_msg");
							
							msg_container
								.append($("<div>").attr({"class":"sent_msg"})
									.append($("<span>").text(item.message_date))
									.append($("<p>").text(item.message))
									.append($("<span>").attr({"class":"unread", "data-unreadlist":item.unread_member_code_list}))
								)
								
							chat_container.append(msg_container);
							
						} else {
							chat_container.addClass("incoming_msg")
							msg_container.addClass("received_msg")
							
							img_container
								.append($("<img>").attr({"class":"rounded-circle", "src":"/resources/images/profileupload/" + member.member_profile_image_s_name}))
							
							var unread_length = item.unread_member_code_list.length;
							if(unread_length == 0){
								unread_length = '읽음'
							}
							
							msg_container
								.append($("<div>").attr({"class":"received_withd_msg"})
									.append($("<span>").text(item.message_date))
									.append($("<p>").text(item.message))
									.append($("<span>").attr({"class":"unread", "data-unreadlist":item.unread_member_code_list}))
									)
									
							chat_container.append(img_container).append(msg_container)
						}
						
					}
				})
				
				$("#messages").append(chat_container);
			})
			
			setUnreadData();
			$('.scroll_fix_bottom').scrollTop($('.scroll_fix_bottom').prop('scrollHeight'));
		}
	</script>
<!-- END :: 채팅 리스트 뿌리기-->

</html>