<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.model.*,org.semanticwb.platform.*,org.semanticwb.portal.*,java.util.*,org.semanticwb.base.util.*"%>
<%
    User user=SWBContext.getSessionUser();
    String lang="es";
    if(user!=null)lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String suri=request.getParameter("suri");
    String smode=request.getParameter("smode");   
    String prop=request.getParameter("prop");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject sobj=ont.getSemanticObject(suri);
    SemanticProperty sprop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticProperty(prop);

    //System.out.println("suri:"+suri);
    //System.out.println("prop:"+prop);
    //System.out.println("smode:"+smode);

    SemanticModel model=sobj.getModel();   
    if(model.getModelObject().instanceOf(UserRepository.sclass))
    {
        UserRepository rep=(UserRepository)model.getModelObject().createGenericInstance();
        Iterator<WebSite> wsit=SWBContext.listWebSites();
        while(wsit.hasNext())
        {
            WebSite site =  wsit.next();
            if(rep.equals(site.getUserRepository()))
            {
                model=site.getSemanticObject().getModel();
            }
        }

    }else if(!model.getModelObject().instanceOf(WebSite.sclass))
    {
        SWBModel rep=(SWBModel)model.getModelObject().createGenericInstance();
        Iterator<WebSite> wsit=SWBContext.listWebSites();
        while(wsit.hasNext())
        {
            WebSite site =  wsit.next();
            if(site.hasSubModel(rep))
            {
                model=site.getSemanticObject().getModel();
            }
        }
        //out.println(rep.getParentWebSite());
    }    
    
    if(smode==null)
    {
        String name=sprop.getName();
        StringBuffer ret=new StringBuffer();
        ret.append("<form id=\""+suri+"/form2\" dojoType=\"dijit.form.Form\" class=\"swbform\" action=\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/propLocaleTextAreaEdit.jsp\" method=\"post\" onsubmit=\"submitForm('"+suri+"/form2');return false;\">");
        ret.append(" <input type=\"hidden\" name=\"suri\" value=\""+suri+"\"/>");
        ret.append(" <input type=\"hidden\" name=\"prop\" value=\""+prop+"\"/>");
        ret.append(" <input type=\"hidden\" name=\"smode\" value=\"edit\"/>");
        ret.append(" <fieldset>");
        ret.append("    <table>");

        Iterator<SemanticObject> it=model.listInstancesOfClass(Language.sclass);
        while(it.hasNext())
        {
            Language lng=(Language)it.next().createGenericInstance();
            ret.append("      <tr>");
            ret.append("        <td><label>"+lng.getDisplayTitle(lang)+":</label></td>");
            String sval=sobj.getProperty(sprop,"",lng.getId());
            sval=sval.replace("\"", "&quot;");
            ret.append("        <td><textarea  name=\""+lng.getId()+"\" style=\"width:300px;height:50px;\" />");
            ret.append(sval);
            ret.append("</textarea></td>");
            ret.append("      </tr>");
        }
        ret.append("    </table>");
        ret.append(" </fieldset>");
        String script="hideDialog();";

        ret.append(" <button dojoType=dijit.form.Button type=\"submit\" name=\"save\">"+SWBUtils.TEXT.getLocaleString("locale_swb_admin", "save", new Locale(lang))+"</button>");
        ret.append(" <button dojoType=dijit.form.Button onclick=\""+script+"\" name=\"return\">"+SWBUtils.TEXT.getLocaleString("locale_swb_admin", "cancel", new Locale(lang))+"</button>");

        ret.append("</form>");
        out.println(ret.toString());
    }else if(smode.equals("edit"))
    {
        
        Iterator<SemanticObject> it=model.listInstancesOfClass(Language.sclass);
        while(it.hasNext())
        {
            Language lng=(Language)it.next().createGenericInstance();
            
            String val=request.getParameter(lng.getId());
            //System.out.println("val:"+val);
            
            if(val!=null)
            {
                if(val.length()==0)
                {
                    sobj.removeProperty(sprop,lng.getId());
                }else
                {
                    sobj.setProperty(sprop, val, lng.getId());
                }
            }            
        }        
%>
    <script type="text/javascript">
        hideDialog();
    </script>
<%        
    }
%>