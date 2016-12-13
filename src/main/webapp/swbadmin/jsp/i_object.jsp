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
    String lang="es";
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    SemanticVocabulary voc=SWBPlatform.getSemanticMgr().getVocabulary();
    String id=request.getParameter("suri");
    
    if(id==null)return;
    
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(id);
    SemanticClass cls=obj.getSemanticClass();    
    
    String title=obj.getDisplayName(lang);
    
    String wid=obj.getModel().getName()+"/"+obj.getId();
    //System.out.println("Title:"+title+" id:"+wid);
%>
    <div id="<%=wid%>" title="<%=title%>" class="panel" selected="true">
        <h2>Propiedades</h2>
        <fieldset>
<%
    Iterator<SemanticProperty> it=cls.listProperties();
    while(it.hasNext())
    {
        SemanticProperty prop=it.next();
        
        if(prop.isDataTypeProperty())
        {
            String value=obj.getProperty(prop);
            if(prop.isInt())value=""+obj.getIntProperty(prop);
            if(prop.isDateTime() && value!=null)value=value.substring(0,10);
            if(value==null)value="";

            
            String label=prop.getDisplayName(lang);
%>
            <div class="row">
                <label><%=label%></label>
<%
                if(prop.isBoolean())
                {
%>    
                <div class="toggle" onclick="send(this)" href="i_update.jsp?suri=<%=obj.getEncodedURI()%>&sprop=<%=prop.getEncodedURI()%>" toggled="<%=value%>"><span class="thumb"></span><span class="toggleOn">ON</span><span class="toggleOff">OFF</span></div>
<%
                }else{
%>  
                <input type="text" onchange="send(this)" href="i_update.jsp?suri=<%=obj.getEncodedURI()%>&sprop=<%=prop.getEncodedURI()%>" value="<%=value%>"/>
<%
                }
%>                
            </div>
<%      }
    }
%>
        </fieldset>

        <h2>Objetos</h2>
        <fieldset>
<%
    it=cls.listProperties();
    while(it.hasNext())
    {
        SemanticProperty prop=it.next();
        if(prop.isObjectProperty())
        {
            String label=prop.getDisplayName(lang);
            if(prop.getLabel()!=null)label=prop.getLabel();
            
            if(prop.getName().startsWith("has"))
            {
                
            }else
            {
                SemanticObject sobj=obj.getObjectProperty(prop);
%>
            <div class="row">
                <a class="select" href="i_select.jsp?suri=<%=obj.getEncodedURI()%>&sprop=<%=prop.getEncodedURI()%>">
<%                
                if(sobj==null)
                {
%>
                    <table width="100%"><tr><td><%=label%></td><td align="right">not set</td></tr></table>
<%
                }else
                {
%>
                    <table width="100%"><tr><td><%=label%></td><td align="right"><a href="i_object.jsp?suri=<%=sobj.getEncodedURI()%>" class="ilink"><%=sobj.getDisplayName(lang)%></a></td></tr></table>
<%
                }
%>
                </a>
            </div>
<%
            }
        }
    }
%>
        </fieldset>
        <fieldset>
            <div class="row">
                <a class="rbutton" href="">Eliminar</a>
            </div>
        </fieldset>
    </div>   