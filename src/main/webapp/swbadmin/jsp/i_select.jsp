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
    SemanticVocabulary voc=SWBPlatform.getSemanticMgr().getVocabulary();
    String id=request.getParameter("suri");
    String idp=request.getParameter("sprop");
    
    if(id==null || idp==null)return;
    
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(id);
    SemanticClass cls=obj.getSemanticClass();    

    SemanticProperty prop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticProperty(idp);
    SemanticClass clsprop=prop.getRangeClass();
    
    String title=prop.getDisplayName();

    String wid=obj.getModel().getName()+"/"+obj.getId()+"/"+prop.getRDFProperty().getLocalName();
    //System.out.println("Title:"+title+" id:"+wid);
%>
    <div id="<%=wid%>" title="<%=title%>" class="panel" selected="true">
        <fieldset>
<%
    Iterator<SemanticObject> it=obj.getModel().listInstancesOfClass(clsprop);
    while(it.hasNext())
    {
        SemanticObject sobj=it.next();
        String stitle=sobj.getDisplayName();
        if(stitle==null)stitle=sobj.getProperty(User.swb_usrLogin);

%>
            <div class="row">
                <a href="i_update.jsp?suri=<%=obj.getEncodedURI()%>&sprop=<%=prop.getEncodedURI()%>&sobj=<%=sobj.getEncodedURI()%>" class="select"><%=stitle%></a>
            </div>
<%
    }
%>
        </fieldset>
    </div>   