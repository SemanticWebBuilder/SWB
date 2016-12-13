<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="java.util.Iterator,org.semanticwb.model.WebPage,org.semanticwb.model.User,java.util.*,org.semanticwb.portal.resources.projectdriver.*" %><%
       User user=paramRequest.getUser();
       ProjectDriverTools tool = new ProjectDriverTools();

        HashMap container = tool.calculateArrayPages(paramRequest.getWebPage().listVisibleChilds(paramRequest.getUser().getLanguage()));
        ArrayList webPage=(ArrayList)container.get("webPage");
        ArrayList proPage=(ArrayList)container.get("proPage");

       if(!proPage.isEmpty())
        out.println(tool.printPage(proPage,paramRequest.getLocaleString("projects"),user,false,""));
       if(!webPage.isEmpty())
        out.println(tool.printPage(webPage,paramRequest.getLocaleString("titleSections"),user,false,""));
%>