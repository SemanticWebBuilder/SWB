<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%!

    public void getAllChilds(List list, SemanticObject obj)
    {
        if(obj!=null)
        {
            if(!list.contains(obj.getURI()))
            {
                list.add(obj.getURI());
                Iterator<SemanticObject> it=obj.listHerarquicalChilds();
                while(it.hasNext())
                {
                    SemanticObject ch=it.next();
                    getAllChilds(list,ch);
                }
            }
        }
    }


%>
<%
  try{

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
    String virp=request.getParameter("virp");
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
    
    SemanticClass cls=obj.getSemanticClass();

    boolean fullaccess=SWBPortal.getAdminFilterMgr().haveAccessToSemanticObject(user, obj);
    boolean classFullAccess=DisplayObject.getDisplayMode(cls).equals(DisplayObject.DISPLAYMODE_FULL_ACCESS) || DisplayObject.getDisplayMode(cls).equals(DisplayObject.DISPLAYMODE_FINAL);        //Nivel de acceso definido por clase en la ontologia   
    
    
    if(!classFullAccess || !fullaccess || !SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_DELETE))
    {
        response.sendError(403);
        return;
    }

    if(obj!=null)
    {
        if(virp!=null)
        {
            SemanticObject vp=ont.getSemanticObject(virp);
            obj.removeObjectProperty(WebPage.swb_hasWebPageVirtualParent, vp);
            out.println("Referencia eliminada...");
            out.println("<script type=\"text/javascript\">reloadTreeNodeByURI('"+vp.getURI()+"',false);</script>");
        }else
        {
            String type=obj.getSemanticClass().getDisplayName(lang);
            ArrayList list=new ArrayList();
            getAllChilds(list, obj);
            boolean trash=false;
            if(obj.instanceOf(Trashable.swb_Trashable))
            {
                boolean del=obj.getBooleanProperty(Trashable.swb_deleted);
                if(!del)trash=true;
            }
            if(!trash)
            {
                obj.remove();
            }else
            {
                obj.setBooleanProperty(Trashable.swb_deleted, true);
            }
            out.println(type+" fue eliminado...");
            out.println("<script type=\"text/javSascript\">");
            Iterator<String> it=list.iterator();
            while(it.hasNext())
            {
                String ch=it.next();
                out.println("closeTab('"+ch+"');");
                //System.out.println(ch);
            }
            out.println("removeTreeNodeByURI('"+obj.getURI()+"',false);");
            out.println("</script>");
        }
    }
    //out.println(obj.getDisplayName(lang)+" "+act);
  }catch(Throwable e){e.printStackTrace();}
%>
<!-- a href="#" onclick="submitUrl('/swb/swb',this); return false;">click</a -->