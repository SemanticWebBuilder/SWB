<%@page import="java.util.Iterator"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.model.*"%>
<%!
   //private int nocache=0;

    public String getLocaleString(String key, String lang)
    {
        return SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new java.util.Locale(lang));
    }
%>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    User user=SWBContext.getSessionUser(SWBContext.USERREPOSITORY_ADMIN);
    if(user==null || !user.isSigned())
    {
        out.println("<div dojoType=\"dijit.layout.ContentPane\" postCreate=\"showDialog('"+SWBPlatform.getContextPath()+"/swbadmin/jsp/login.jsp','Login');\" />");
        return;
    }
    String lang=user.getLanguage();
    String id=request.getParameter("id");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(id);
    GenericObject gen=obj.createGenericInstance();
    SemanticClass cls=obj.getSemanticClass();
    String title=obj.getDisplayName(lang);
    String url=null;
    if(gen instanceof WebPage)url=((WebPage)gen).getUrl();
    if(gen instanceof WebSite)url=SWBPortal.getDistributorPath()+"/"+gen.getId();
    if(cls.getClassId().equals("swp:Process"))
    {
        SemanticProperty prop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticPropertyById("swp:processWebPage");
        SemanticObject swp=obj.getObjectProperty(prop);
        if(swp!=null)
        {
            WebPage wp=(WebPage)swp.createGenericInstance();
            url=wp.getUrl();
        }
    }

    String description=obj.getProperty(Descriptiveable.swb_description);
    if(description!=null && description.length()>25)description=description.substring(0,25);
    String active=obj.getProperty(Activeable.swb_active);
    String sortname=obj.getProperty(WebPage.swb_webPageSortName);
%>
<table>
    <!--<caption>Propiedades</caption>-->
    <tr><th><%=getLocaleString("property",lang)%></th><th><%=getLocaleString("value",lang)%></th></tr>
<%
    if(url!=null)
    {
%>
        <tr><td><%=getLocaleString("identificator",lang)%></td><td><a href="<%=url%>" onclick="showPreviewURL('<%=url%>');return false;"><%=obj.getId()%></a></td></tr>
<%
    }else
    {
%>
        <tr><td><%=getLocaleString("identificator",lang)%></td><td><%=obj.getId()%></td></tr>
<%
    }
%>
    <tr><td>Model</td><td><%=obj.getModel().getName()%></td></tr>
    <tr><td>Class</td><td><%=cls.getName()%></td></tr>
    <%if(cls.getDisplayNameProperty()!=null){%><tr><td><%=cls.getDisplayNameProperty().getDisplayName(lang)%></td><td><%=title%></td></tr><%}%>
    <%if(sortname!=null){%><tr><td><%=WebPage.swb_webPageSortName.getDisplayName(lang)%></td><td><%=sortname%></td></tr><%}%>
    <%if(active!=null){%><tr><td><%=Activeable.swb_active.getDisplayName(lang)%></td><td><%=active%></td></tr><%}%>
    <%if(description!=null){%><tr><td><%=Descriptiveable.swb_description.getDisplayName(lang)%></td><td><%=description%></td></tr><%}%>
</table>