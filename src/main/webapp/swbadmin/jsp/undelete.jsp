<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    String lang=user.getLanguage();

    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String suri=request.getParameter("suri");
    //System.out.println("suri:"+suri);
    if(suri==null)
    {
        String code=SWBUtils.IO.readInputStream(request.getInputStream());
        //System.out.println(code);
        String uri=SWBContext.getAdminWebSite().getHomePage().getEncodedURI();
%>
    Error params not found...
    <a href="?suri=<%=uri%>">edit</a>
<%
        return;
    }

    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(suri);

    boolean fullaccess=SWBPortal.getAdminFilterMgr().haveAccessToSemanticObject(user, obj);
    if(!fullaccess || !SWBPortal.getAdminFilterMgr().haveClassAction(user, obj.getSemanticClass(), AdminFilter.ACTION_DELETE))
    {
        response.sendError(403);
        return;
    }

    if(obj!=null)
    {
        String type=obj.getSemanticClass().getDisplayName(lang);
        boolean trash=false;
        if(obj.instanceOf(Trashable.swb_Trashable))
        {
            trash=true;
        }else
        {
            out.println("Error restoring object...");
            return;
        }
        if(trash)
        {
            obj.setBooleanProperty(Trashable.swb_deleted, false);
        }
        out.println(type+" fue recuperado...");
        SemanticObject parent=obj.getHerarquicalParent();
        if(parent==null)parent=obj.getModel().getModelObject();

        out.println("<script type=\"text/javascript\">");
        //out.println("removeTreeNodeByURI('"+obj.getURI()+"',false);");

        if(obj.instanceOf(WebSite.sclass))
        {
            out.println("addItemByURI(mtreeStore, null, '" + obj.getURI() + "');");
        }else 
        {
            out.println("reloadTreeNodeByURI('"+parent.getURI()+"');");
        }
        out.println("reloadTab('"+obj.getURI()+"');");
        out.println("</script>");
    }
    //out.println(obj.getDisplayName(lang)+" "+act);
%>
<!-- a href="#" onclick="submitUrl('/swb/swb',this); return false;">click</a -->