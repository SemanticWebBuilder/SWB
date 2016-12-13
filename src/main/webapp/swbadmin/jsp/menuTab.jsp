<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
%>
<%
    String lang="es";
    if(user!=null)lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String id=request.getParameter("suri");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    GenericObject obj=ont.getGenericObject(id);
    org.semanticwb.model.MenuItem mnu=null;
    //System.out.println("id:"+id+" "+obj.getClass());
    if(obj==null)return;
    if(obj instanceof org.semanticwb.model.MenuItem)
    {
        mnu=(MenuItem)obj;
    }

    if(!SWBPortal.getAdminFilterMgr().haveAccessToWebPage(user, mnu))
    {
        return;
    }

    //System.out.println("mnu:"+mnu);
    if(mnu.getShowAs()==null || mnu.getShowAs().equals("CONTENT"))
    {
        out.println("<div dojoType=\"dijit.layout.ContentPane\" title=\""+mnu.getDisplayName(lang)+"\" refreshOnShow=\""+"false"+"\" href=\""+mnu.getUrl()+"\" loadingMessage=\"<center><img src='"+SWBPlatform.getContextPath()+"/swbadmin/images/loading.gif'/><center>\" _onLoad=\"alert('test');\">");
        out.println("</div>");
    }else if(mnu.getShowAs().equals("IFRAME"))
    {
        out.println("<iframe dojoType_=\"dijit.layout.ContentPane\" src=\""+mnu.getUrl()+"\" width=\"100%\" height=\"100%\" frameborder=\"0\" scrolling=\"yes\"></iframe>");
    }
    //System.out.println(obj.getUrl());
    //String title=obj.getSemanticObject().getProperty(SWBContext.getVocabulary().title);

    //out.println("<div id=\""+obj.getURI()+"/menu"+"\" dojoType=\"dijit.layout.ContentPane\" title=\""+obj.getDisplayName(lang)+"\" refreshOnShow=\""+"false"+"\" href=\""+obj.getUrl()+"\" _onLoad=\"alert('test');\">");
    //out.println("</div>");

%>
