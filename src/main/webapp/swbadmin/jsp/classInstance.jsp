<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
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
    String lang=user.getLanguage();

    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    String suri=request.getParameter("suri");

    String pathView=SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp";

    //out.println(suri+" "+Thread.currentThread().getName());
    //SemanticOntology ont=(SemanticOntology)session.getAttribute("ontology");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getSchema();
    
    OntClass cls=ont.getRDFOntModel().getOntClass(suri);
%>
    <table width="100%">
        <thead>
            <tr>
                <th>Instancia</th>
                <th>Tipo</th>
                <th>Etiqueta</th>
                <th>Comentario</th>
<!--                <th>Modelo</th>
                <th>URI</th>-->
            </tr>
        </thead>
    <tbody>
<%
    Property label=ont.getRDFOntModel().getProperty(SemanticVocabulary.RDFS_LABEL);
    Property comment=ont.getRDFOntModel().getProperty(SemanticVocabulary.RDFS_COMMENT);
    Property type=ont.getRDFOntModel().getProperty(SemanticVocabulary.RDF_TYPE);
    Iterator itp=cls.listInstances();
    while(itp.hasNext())
    {
        Resource obj=(Resource)itp.next();
        out.print("<tr>");
        out.print("<td>"+SWBPlatform.JENA_UTIL.getLink(obj,pathView)+"</td>");
        out.print("<td>"+SWBPlatform.JENA_UTIL.getObjectLink(obj,type,ont.getRDFOntModel(),pathView)+"</td>");
        out.print("<td>"+SWBPlatform.JENA_UTIL.getTextLocaled(obj,label)+"</td>");
        out.print("<td>"+SWBPlatform.JENA_UTIL.getTextLocaled(obj,comment)+"</td>");
        //out.print("<td>"+obj.getModel()+"</td>");
        //out.print("<td>"+obj.getURI()+"</td>");
        out.println("</tr>");
    }
%>
    </tbody>
    </table>
