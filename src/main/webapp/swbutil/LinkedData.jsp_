<%@page import="org.semanticwb.platform.SemanticProperty"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.platform.SemanticMgr"%>
<%@page import="org.semanticwb.model.SWBModel"%><%@page import="java.util.Iterator"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="com.hp.hpl.jena.rdf.model.*"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.model.WebSite"%><%@page import="org.semanticwb.model.SWBContext"%><%@page contentType="text/xml" pageEncoding="UTF-8"%><%
    String sid=request.getParameter("sid");
    String m=request.getParameter("m");
    
    if(m==null)m="demo";
    WebSite site=SWBContext.getWebSite(m);
    
    SemanticObject obj=null;
    if(sid==null)obj=site.getSemanticObject();
    else
    {
        String uri=site.getNameSpace()+sid;
        obj=site.getSemanticModel().getSemanticObject(uri);
    }
    
    ByteArrayOutputStream bout=new ByteArrayOutputStream();
    
    Model model=ModelFactory.createDefaultModel();
    model.add(obj.getRDFResource().listProperties());
    
    Iterator<Statement> its=site.getSemanticModel().getRDFModel().listStatements(null, null, obj.getRDFResource());
    while(its.hasNext())
    {
        Statement st=(Statement)its.next();
        SemanticProperty prop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticProperty(st.getPredicate());
        Resource res=st.getSubject();
        if(res!=null)
        {
            if(prop.isInverseOf())
            {
                model.add(obj.getRDFResource(), prop.getInverse().getRDFProperty(), res);        
            }
        }
    }     
    
    // "RDF/XML", "RDF/XML-ABBREV", "N-TRIPLE" and "N3"
    model.write(bout, "RDF/XML");
    
    String txt=bout.toString("UTF8"); 
    
    txt=txt.replace("http://www.semanticwebbuilder.org/", "http://www.semanticwebbuilder.org.mx/");
    
    Iterator<SWBModel> it=SWBContext.listSWBModels(false);
    while(it.hasNext())
    {
        SWBModel smodel=it.next();
        txt=txt.replace(smodel.getSemanticModel().getNameSpace(), request.getRequestURL()+"?m="+smodel.getId()+"&amp;sid=");
    }    
    out.print(txt);
%>