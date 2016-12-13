<%@page import="java.io.ByteArrayOutputStream"%><%@page import="com.hp.hpl.jena.rdf.model.ModelFactory"%><%@page import="com.hp.hpl.jena.rdf.model.Model"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="java.util.Iterator"%><%@page import="org.semanticwb.model.WebSite"%><%@page import="org.semanticwb.model.SWBContext"%><%@page import="com.hp.hpl.jena.rdf.model.StmtIterator"%><%@page import="com.hp.hpl.jena.rdf.model.Resource"%><%@page import="org.semanticwb.platform.SemanticProperty"%><%@page import="com.hp.hpl.jena.rdf.model.Statement"%><%@page import="org.semanticwb.SWBPlatform"%><%@page import="org.semanticwb.platform.SemanticVocabulary"%><%@page import="org.semanticwb.platform.SemanticObject"%><%@page import="java.util.ArrayList"%><%@page contentType="text/plain" pageEncoding="UTF-8"%><%!




    public void getDependencies(SemanticObject object, ArrayList<SemanticObject> stack, ArrayList<Statement> triples)
    {
        System.out.println("getDependencies:"+object);
        stack.add(object);
        //System.out.println("getDependencies"+stack);
        SemanticVocabulary v=SWBPlatform.getSemanticMgr().getVocabulary();
        
        
        Iterator<Statement> it=SWBUtils.Collections.copyIterator(object.getRDFResource().listProperties()).iterator();
        while (it.hasNext()) 
        {
            Statement st = it.next();
            triples.add(st);
            SemanticProperty prop=v.getSemanticProperty(st.getPredicate());
            //System.out.println("prop 1:"+prop+" "+prop.isRemoveDependency());

            if(prop.isObjectProperty())
            {
                if(prop.isRemoveDependency())
                {
                    Resource res=st.getResource();
                    if(res!=null)
                    {
                        SemanticObject obj=SemanticObject.createSemanticObject(res);
                        //System.out.println("res 1:"+res+" "+obj);
                        if(obj!=null && stack!=null && !stack.contains(obj))
                        {
                            getDependencies(obj, stack,triples);
                        }
                    }
                }else if(prop.isInverseOf())
                {
                //    remove(st);
                }
            }
            
        }
        
        //Busca Inversas
        it=SWBUtils.Collections.copyIterator(object.getModel().getRDFModel().listStatements(null, null, object.getRDFResource())).iterator();
        while (it.hasNext()) 
        {
            Statement st = it.next();
            SemanticProperty prop=v.getSemanticProperty(st.getPredicate());
            Resource res=st.getSubject();
            if(res!=null)
            {
                SemanticObject obj=SemanticObject.createSemanticObject(res);
                //System.out.println("res 2:"+res+" "+obj);
                //System.out.println("prop 2:"+prop+" "+prop.isInverseOf()+prop.getInverse());
                
                if(prop.isInverseOf() && prop.getInverse().isRemoveDependency())
                {
                    if(obj!=null && stack!=null && !stack.contains(obj))getDependencies(obj, stack,triples);
                }else
                {
                    //if(obj!=null)obj.remove(st);
                    triples.add(st);
                }
            }
        }        
    }

%><%
    String smodel=request.getParameter("model");
    String id=request.getParameter("id");
    if(smodel==null && id==null)return;
    
    WebSite site=SWBContext.getWebSite(smodel);
    SemanticObject object=site.getWebPage(id).getSemanticObject();
    System.out.println(object);

    ArrayList<SemanticObject> stack=new ArrayList();
    ArrayList<Statement> triples=new ArrayList();
    getDependencies(object, stack, triples);
    
    Model model=ModelFactory.createDefaultModel();
    
    Iterator<Statement> it=triples.iterator();
    while(it.hasNext())
    {
        model.add(it.next());
    }
    // "RDF/XML", "RDF/XML-ABBREV", "N-TRIPLE" and "N3"
    ByteArrayOutputStream bout=new ByteArrayOutputStream();
    
    //model.write(bout, "RDF/XML");    
    model.write(bout, "N-TRIPLE");    
    String txt=bout.toString("UTF8"); 
    out.print(txt);
%>
