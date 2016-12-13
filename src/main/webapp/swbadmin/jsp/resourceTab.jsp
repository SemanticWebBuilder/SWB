<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.SWBContext"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,java.util.*,org.semanticwb.base.util.*,com.hp.hpl.jena.ontology.*,com.hp.hpl.jena.rdf.model.*"%>
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
    String id=request.getParameter("suri");
    //out.println("suri1:"+id);
    int ind=id.indexOf('|');
    if(ind>0)
    {
        id=id.substring(0,ind);
    }
    //out.println("suri2:"+id);
    //SemanticOntology ont=(SemanticOntology)session.getAttribute("ontology");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getSchema();
    //System.out.println("suri:"+id);
    OntResource res=ont.getRDFOntModel().getOntResource(id);
    //System.out.println("res:"+res);
    if(res==null)
    {
        out.println("Resource: "+id+" not found...");
        return;
    }
    boolean isClass=res.isClass();
    //System.out.println("isClass:"+isClass);

    //Div dummy para detectar evento de carga y modificar titulo
    String icon="swbIconClass";
    //out.println("<div dojoType=\"dijit.layout.ContentPane\" postCreate=\"setTabTitle('"+id+"','"+cls.getLocalName()+"','"+icon+"');\" />");
    String eid=URLEncoder.encode(id);

    out.println("<div dojoType=\"dijit.layout.TabContainer\" region=\"center\" style=\"width=100%;height=100%;\" id=\""+id+"/tab2\" nested_=\"true\">");

    out.println("<div dojoType=\"dijit.layout.ContentPane\" title=\"Información\" refreshOnShow=\"true\" href=\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceInfo.jsp?suri="+eid+"\" >");
    out.println("</div>");
    if(isClass)
    {
        out.println("<div dojoType=\"dijit.layout.ContentPane\" title=\"Instancias\" refreshOnShow=\"true\" href=\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/classInstance.jsp?suri="+eid+"\" >");
        out.println("</div>");
        out.println("<div dojoType=\"dijit.layout.ContentPane\" title=\"Dominio\" refreshOnShow=\"true\" href=\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/classDomain.jsp?suri="+eid+"\" >");
        out.println("</div>");
    }
    out.println("</div><!-- end Bottom TabContainer -->");

%>