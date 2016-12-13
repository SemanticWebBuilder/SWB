<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String suri=request.getParameter("suri");
    String sprop=request.getParameter("sprop");
    String sobj=request.getParameter("sobj");
    String sval=null;
    if(sobj==null)
    {
        sval=SWBUtils.TEXT.decode(request.getParameter("sval"),"UTF-8");
    }
    
    //System.out.println("suri="+suri);
    //System.out.println("sprop="+sprop);
    //System.out.println("sval="+sval);
    //System.out.println("sobj="+sobj);
    
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(suri);
    SemanticClass cls=obj.getSemanticClass();
    
    SemanticProperty prop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticProperty(sprop);
    if(sval!=null)
    {
        if(sval.length()>0)
        {
            if(prop.isBoolean())obj.setBooleanProperty(prop, Boolean.parseBoolean(sval));
            if(prop.isInt())obj.setLongProperty(prop, Integer.parseInt(sval));
            if(prop.isString())obj.setProperty(prop, sval);
        }else
        {
            obj.removeProperty(prop);
        }
    }else if(sobj!=null)
    {
        SemanticObject aux=ont.getSemanticObject(sobj);
        if(sobj!=null)
        {
            obj.setObjectProperty(prop, aux);
        }else
        {
            obj.removeProperty(prop);
        }
        response.sendRedirect("i_object.jsp?suri="+obj.getEncodedURI());
    }
%>    
    
