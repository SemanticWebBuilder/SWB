<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.util.*,java.io.PrintWriter,java.text.*,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.resources.projectdriver.*,org.semanticwb.portal.api.*,org.semanticwb.portal.*,java.sql.Timestamp"%>
<%
        WebPage wp = paramRequest.getWebPage();
        User user = paramRequest.getUser();
        Iterator<UserWebPage> it = UserWebPage.ClassMgr.listUserWebPageByParent(wp, wp.getWebSite());
        Iterator<WebPage> itwp = wp.listVisibleChilds(paramRequest.getUser().getLanguage());
        ProjectDriverTools tool = new ProjectDriverTools();
        HashMap container = tool.calculateArrayPages(itwp);
        ArrayList webPage = (ArrayList)container.get("webPage");

%>
    <script type="text/javascript" src="/swbadmin/jsp/projectDriver/projectdriver.js"></script>
    <link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/projectDriver/projectdriver.css" rel="stylesheet" type="text/css" />
<div id="proyecto"><%
if(it.hasNext())
   {
      ArrayList userValid=tool.getUserValid(wp); 
      HashMap users =tool.getMapUsers(userValid,tool.getProject(wp),user);
      ArrayList actValid = tool.calcProgressUserGral(users);
      String avanTot=tool.getProgressBar(actValid,paramRequest.getLocaleString("msgTotalHours"));
      if(avanTot==null)
          avanTot=paramRequest.getLocaleString("msgNoProgress");
        %>
      <fieldset><legend><%=paramRequest.getLocaleString("labelTotalProgress")%></legend>
            <div class="avanTot"><%=avanTot%>
            </div>
      </fieldset><%
       Iterator ita=userValid.iterator();
        if(ita.hasNext()){
%>
      <h2><%=paramRequest.getLocaleString("titleAssociatedPersonnel")%></h2><br><%
        out.println(tool.viewListUsers(users,ita,paramRequest.getLocaleString("msgTotalHours"),paramRequest.getLocaleString("msgNoProgress")));
        }
        if(!webPage.isEmpty()){
            out.println("\n");
            out.println(tool.printPage(webPage,paramRequest.getLocaleString("titleSections"),user,false,""));
        }
   }else{%>
         <fieldset><legend><%=paramRequest.getLocaleString("labelTotalProgress")%></legend>
            <%=paramRequest.getLocaleString("msgNoUsers")%>
         </fieldset>
<%}%>
</div>

