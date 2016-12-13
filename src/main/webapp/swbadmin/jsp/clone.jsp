package swbadmin.jsp;

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%!

%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    String lang="es";
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String suri=request.getParameter("suri");
    //System.out.println("suri:"+suri);
    if(suri==null)
    {
        String code=SWBUtils.IO.readInputStream(request.getInputStream());
        System.out.println(code);
        String uri=SWBContext.getAdminWebSite().getHomePage().getEncodedURI();
%>
    Error params not found...
    <a href="?suri=<%=uri%>">clone</a>
<%
        return;
    }

    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(suri);
    if(obj!=null)
    {
        String type=obj.getSemanticClass().getDisplayName(lang);
        SemanticObject obj2=obj.cloneObject();
        out.println(type+" fue clonado...");
        SemanticObject pobj=obj.getHerarquicalParent();
        if(pobj!=null)
        {
            out.println("<script type=\"text/javascript\">reloadTreeNodeByURI('"+pobj.getURI()+"');</script>");
        }
    }
    //out.println(obj.getDisplayName(lang)+" "+act);
%>
<!-- a href="#" onclick="submitUrl('/swb/swb',this); return false;">click</a -->