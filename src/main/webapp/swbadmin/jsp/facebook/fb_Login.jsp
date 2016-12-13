<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>


    <%
        String API_KEY=(String)request.getAttribute("API_KEY");
        String SECRET_KEY=(String)request.getAttribute("SECRET_KEY");
        String reditect=(String)request.getAttribute("redirect");
        String step=(String)request.getAttribute("step");
        if(step.equals("1")){
            %>
                <div id="user"><fb:login-button onlogin="update_user_box();"></fb:login-button></div>
                <%=getScript(API_KEY, reditect, paramRequest)%>
            <%
        }else if(step.equals("2")){
            %>
                <div id="user"></div>
                <%=getScript(API_KEY, reditect, paramRequest)%>
                <script type="text/javascript">update_user_box();</script>
                <script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/XdCommReceiver.js" type="text/javascript"></script>
            <%
        }else if(step.equals("3")){
            %>
                <script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/XdCommReceiver.js" type="text/javascript"></script>
            <%
        }
    %>


    <%!
    private String getScript(String API_KEY, String redirect, SWBParamRequest paramRequest){
            StringBuffer strbf=new StringBuffer();
            try{
                strbf.append("<script type=\"text/javascript\">");
                strbf.append("function onNotConnected(){");
                strbf.append("}");
                strbf.append("function onConnected(user_id){");
                strbf.append("   ");
                strbf.append("}");
                strbf.append("</script>");
                strbf.append("<script type=\"text/javascript\">");
                strbf.append("function update_user_box() {");
                strbf.append("var user_box = document.getElementById(\"user\");");
                strbf.append("user_box.innerHTML =\"");
                strbf.append("<span>");
                strbf.append("<fb:profile-pic uid=loggedinuser facebook-logo=true></fb:profile-pic>");
                strbf.append(paramRequest.getLocaleString("welcome")+"<fb:name uid=loggedinuser useyou=false></fb:name>"+paramRequest.getLocaleString("afterWelcome"));
                strbf.append("</span>\";");
                strbf.append("FB.XFBML.Host.parseDomTree();");
                strbf.append("}");
                strbf.append("</script>");
                strbf.append("<script type=\"text/javascript\" src=\"http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php\"></script>");
                strbf.append("<script type=\"text/javascript\">");
                //strbf.append("FB.init(\""+API_KEY+"\",\""+redirect+"?swb=1\", {\"ifUserConnected\":onConnected,\"ifUserNotConnected\":onNotConnected});");
                strbf.append("FB.init(\""+API_KEY+"\",\""+redirect+"?swb=1\");");
                strbf.append("</script>");
             }catch(Exception e){
                 e.printStackTrace();
             }
            return strbf.toString();
        }
    %>