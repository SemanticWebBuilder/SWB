<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.util.*,java.io.PrintWriter,java.text.*,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.resources.projectdriver.*,org.semanticwb.portal.api.*,org.semanticwb.portal.*,java.sql.Timestamp"%>
<%
    WebPage wp=paramRequest.getWebPage();
    User user=paramRequest.getUser();
    Iterator it=wp.listVisibleChilds(user.getLanguage());
    ProjectDriverTools tool = new ProjectDriverTools();
    WebPage parent=tool.getProject(wp);
    String avan = tool.getProgressBar(tool.getListLeafActivities(wp,user),paramRequest.getLocaleString("msgTotalHours"));
    if(avan==null)avan = paramRequest.getLocaleString("msgNoProgress");
%>
    <script type="text/javascript" src="/swbadmin/jsp/projectDriver/projectdriver.js"></script>
    <link href="<%=org.semanticwb.SWBPlatform.getContextPath()%>/swbadmin/jsp/projectDriver/projectdriver.css" rel="stylesheet" type="text/css" />
<div id="proyecto">
    <div class="datos">
        <div class="global">
            <div class="etiquetas"><%=paramRequest.getLocaleString("titleProject")%>: </div>
            <div class="elementos"><%=parent.getDisplayName()%></div>
        </div>
        <div class="globalA">
            <div class="etiquetas"><%=paramRequest.getLocaleString("labelActivitiesProgress")%>: </div>
            <div class="barraDatos"><%=avan%>
            </div>
        </div>
    </div>
<%
          if(it.hasNext())
          {
            HashMap container=tool.calculateArrayPages(it);
            ArrayList webPage=(ArrayList)container.get("webPage");
            out.println(tool.getWebPageListLevel(wp,user,3,paramRequest.getLocaleString("titleActivities"),"",paramRequest.getLocaleString("msgTotalHours")));
            if(!webPage.isEmpty())
              out.println(tool.printPage(webPage,paramRequest.getLocaleString("titleSections"),user,false,""));
          }%>
</div>