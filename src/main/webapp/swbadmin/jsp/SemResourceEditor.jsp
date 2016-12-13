<%@page import="org.semanticwb.model.SWBContext"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="com.hp.hpl.jena.vocabulary.RDFS"%>
<%@page import="java.io.IOException"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,java.util.*,org.semanticwb.base.util.*,com.hp.hpl.jena.ontology.*,com.hp.hpl.jena.rdf.model.*"%>
<%!
    public void renderProperty(Resource res, SemanticProperty sprop, JspWriter out, String elemid, String oval) throws IOException
    {
        String val=oval;
        if(val==null)val="";
        if(sprop.isBoolean())
        {
            out.println("<select id=\""+elemid+"\" dojoType=\"dijit.form.FilteringSelect\" autoComplete=\"true\" style=\"width:400px;font-size:12;\">");

            out.print("<option value=\"false\" ");
            if (oval!=null && oval.equals("false"))out.print("selected");
            out.println(">false</option>");

            out.print("<option value=\"true\" ");
            if (oval!=null && oval.equals("true"))out.print("selected");
            out.println(">true</option>");

            out.println("</select>");

        }else if (sprop.isInt() || sprop.isLong())
        {
            out.println("<input type=\"text\" id=\""+elemid+"\" dojoType=\"dijit.form.ValidationTextBox\" style=\"width:400px;font-size:12;\" regExp=\"\\d+\" value=\""+val+"\" trim=\"true\"/>");
        }else
        {
            out.println("<input type=\"text\" id=\""+elemid+"\" dojoType=\"dijit.form.ValidationTextBox\" style=\"width:400px;font-size:12;\" value='"+val+"' trim=\"true\"/>");
        }
    }

    public void renderOkCancelButton(Resource res, Property prop, JspWriter out, String divid, String elemid, String oval, String action) throws IOException
    {
        out.println("<button dojoType=\"dijit.form.Button\" type=\"button\">");
        out.println("<span>ok</span>");
        out.println("  <script type=\"dojo/method\" event=\"onClick\">");
        out.println("    var self = document.getElementById(\""+elemid+"\");");
        out.println("    var di = dijit.byId('"+elemid+"');");
        out.println("    if(di.isValid()){");
        out.print("    getHtml(\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceInfo.jsp?suri="+URLEncoder.encode(res.getURI())+"&puri="+URLEncoder.encode(prop.getURI())+"&act="+action);
        if(oval!=null)out.print("&oval="+URLEncoder.encode(oval));
        out.println("&val=\"+escape(self.value),\""+divid+"\",true);");
        out.println("    }");
        out.println("  </script>");
        out.println("</button>");
        out.println("<button dojoType=\"dijit.form.Button\" type=\"button\">");
        out.println("<span>cancel</span>");
        out.println("  <script type=\"dojo/method\" event=\"onClick\">");
        out.println("    getHtml(\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceInfo.jsp?suri="+URLEncoder.encode(res.getURI())+"&puri="+URLEncoder.encode(prop.getURI())+"\",\""+divid+"\",true);");
        out.println("  </script>");
        out.println("</button>");
    }

    public void renderPropValues(Resource res, Property prop, JspWriter out, boolean isbase, boolean addempty, String editValue) throws IOException
    {
        SemanticProperty sprop=new SemanticProperty(prop);
        System.out.println(sprop+" "+sprop.getRange());
        String pathView=SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp";

        out.println("<table border=0>");

        String divid=res.getURI()+"_"+prop.getURI();
        String elemid = "val_"+divid;

        //Agregar nuevo
        if(addempty)
        {
            out.println("<tr><td width=400>");
            renderProperty(res, sprop, out, elemid, null);
            out.println("</td><td>");
            renderOkCancelButton(res, prop, out, divid, elemid, null, "add");
            out.println("</td></tr>");
        }

        Iterator<Statement> itp=res.listProperties(prop);
        if(itp.hasNext())
        {
            while(itp.hasNext())
            {
                Statement stmt=itp.next();
                RDFNode node=stmt.getObject();

                String val="";
                String oval="";
                if(node.isResource())
                {
                    oval=SWBPlatform.JENA_UTIL.getId(stmt.getResource());
                    val=SWBPlatform.JENA_UTIL.getLink(stmt.getResource(),pathView);
                }else
                {
                    val=stmt.getString();
                    oval=val;
                    String lang=stmt.getLanguage();
                    if(lang!=null && lang.length()>0)val+=" {@"+lang+"}";
                }
                if(isbase)
                {
                    if(editValue!=null && editValue.equals(oval))
                    {
                        //System.out.println("base..");
                        out.println("<tr><td width=400>");
                        renderProperty(res, sprop, out, elemid, oval);
                        out.println("</td><td>");
                        renderOkCancelButton(res, prop, out, divid, elemid, oval, "update");
                        out.println("</td></tr>");
                    }else
                    {
                        //System.out.println("base..");
                        out.println("<tr><td width=400>");
                        //out.println("<input type='text' dojoType='dijit.form.ValidationTextBox' style=\"width:400px;font-size:12;\" value='"+val+"'/>"); // <a href=\"#\">");
                        out.print("<div style=\"background-color:#FFFFFF; cursor:text; font:11px; width:400px; border:#A0A0FF solid 1px;\" onclick='");
                        out.print("getHtml(\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceInfo.jsp?suri="+URLEncoder.encode(res.getURI())+"&puri="+URLEncoder.encode(prop.getURI())+"&act=edit&val="+URLEncoder.encode(oval)+"\",\""+divid+"\",true);");
                        out.print("'>"+val+"</div>");
                        out.println("</td><td>");
                        out.println("<button dojoType=\"dijit.form.Button\" type=\"button\">");
                        out.println("<span>remove</span>");
                        out.println("  <script type=\"dojo/method\" event=\"onClick\">");
                        out.println("    getHtml(\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceInfo.jsp?suri="+URLEncoder.encode(res.getURI())+"&puri="+URLEncoder.encode(prop.getURI())+"&act=remove&val="+URLEncoder.encode(oval)+"\",\""+divid+"\",true);");
                        out.println("  </script>");
                        out.println("</button>");
                        out.println("</td></tr>");
                    }
                }else
                {
                    out.println("<tr><td width=400>");
                    out.println("<div style=\"background-color:#FFFFFF; font:11px; width:400px; border:#A0A0FF solid 1px;\">"+val+"</div>");
                    out.println("</td><td>");
                    out.println("</td></tr>");
                }
                //if(itp.hasNext())out.println("<br/>");
            }
        }
        out.println("</table>");
    }


%>

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
    String puri=request.getParameter("puri");
    String act=request.getParameter("act");
    String sref=request.getParameter("sref");

    //System.out.println("suri:"+suri);
    String pathView=SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp";

    //out.println("suri:"+suri);
    SemanticOntology ont=(SemanticOntology)session.getAttribute("ontology");
    Resource res=SWBPlatform.JENA_UTIL.getBaseModelResource(suri, ont.getRDFOntModel());
    //out.println("res:"+res);
    boolean isbase=SWBPlatform.JENA_UTIL.isInBaseModel(res,ont.getRDFOntModel());

    if(puri!=null)
    {
        Property prop=ont.getRDFOntModel().getOntProperty(puri);
        String editValue=null;

        if(act!=null && act.equals("add"))
        {
            String val=request.getParameter("val");
            res.addProperty(prop, val);
        }else if(act!=null && act.equals("remove"))
        {
            String val=request.getParameter("val");
            StmtIterator  it = res.listProperties(prop);
            while (it.hasNext())
            {
                Statement stmt=it.nextStatement();
                RDFNode node=stmt.getObject();
                System.out.println(node+" "+val);
                if(node.toString().equals(val))
                {
                    it.remove();
                    break;
                }
            }
            it.close();
        }else if(act!=null && act.equals("update"))
        {
            String oval=request.getParameter("oval");
            String val=request.getParameter("val");
            StmtIterator  it = res.listProperties(prop);
            while (it.hasNext())
            {
                Statement stmt=it.nextStatement();
                RDFNode node=stmt.getObject();
                //System.out.println(node+" "+val);
                if(node.toString().equals(oval))
                {
                    it.remove();
                    break;
                }
            }
            it.close();
            res.addProperty(prop, val);
        }else if(act!=null && act.equals("edit"))
        {
            editValue=request.getParameter("val");
        }

        renderPropValues(res, prop, out, isbase, act!=null && act.equals("addempty"),editValue);
        return;
    }else if(sref!=null)
    {
        System.out.print("sref"+sref);
        System.out.print("act"+act);
        //Property prop=ont.getRDFOntModel().getOntProperty(puri);
        //String editValue=null;
        if(act!=null && act.equals("add"))
        {
            String id=request.getParameter("id");
            System.out.print("id:"+act);
        }
    }

    //System.out.println("isbase:"+isbase);

%>
<form dojoType="dijit.form.Form" id="<%=suri%>/form"  class="swbform">
    <input type="hidden" name="suri" value="<%=suri%>"/>
    <fieldset>
        <table>
            <tr>
                <td width="200px" align="right">
                    <label>Name: </label>
                </td>
                <td>
<%
    if(isbase)
    {
        out.println("<input type='text'  dojoType='dijit.form.TextBox' style='width:400px;font-size:12;' value='"+SWBPlatform.JENA_UTIL.getId(res)+"'/>");
    }else
    {
        out.println("<span>"+SWBPlatform.JENA_UTIL.getLink(res,pathView)+"</span>");
    }
%>
                </td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <legend>Datos de la Clase</legend>
        <table border="0">
<%
    //System.out.println("paso 2");
    int num=0;
    Iterator<Property> it=SWBPlatform.JENA_UTIL.getClassProperties(res, ont.getRDFOntModel());
    while(it.hasNext())
    {
        num++;
        Property prop=it.next();
        OntProperty oprop=null;
        try{oprop=(OntProperty)prop.as(OntProperty.class);}catch(Exception noe){}
        //System.out.println("paso 3:"+prop+" "+oprop);
        out.println("<tr><td width=\"200px\" align=\"right\" valign=\"top\">");
        out.println("<label>"+SWBPlatform.JENA_UTIL.getLink(prop,pathView)+"&nbsp;</label>");
        out.println("</td><td>");
        out.println("<span>");
        String divid=res.getURI()+"_"+prop.getURI();
        if(isbase)
        {
            String addempty="getHtml(\""+SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceInfo.jsp?suri="+URLEncoder.encode(res.getURI())+"&puri="+URLEncoder.encode(prop.getURI())+"&act=addempty\",\""+divid+"\",true);";
%>
            <div dojoType="dijit.form.DropDownButton" optionsTitle_='Add' title_="Add" iconClass_="plusBlockIcon" showLabel="false">
                <span>Add</span>
                <div dojoType="dijit.Menu" style="display: none;">
                    <div dojoType="dijit.MenuItem"  iconClass_="dijitEditorIcon dijitEditorIconSave" onClick='<%=addempty%>'>Add empty</div>
<%
            if(oprop!=null && (oprop.isObjectProperty() || (oprop.getRange()!=null && oprop.getRange().equals(RDFS.Class))))
            {
                out.println("<div dojoType=\"dijit.MenuItem\"  onClick=''>Add existing</div>");
                out.println("<div dojoType=\"dijit.MenuItem\"  onClick=''>Create and add</div>");
            }
%>
                </div>
            </div>
<%
        }
        out.println("</span>");
        out.println("<div id=\""+divid+"\">");
        renderPropValues(res,prop,out,isbase,false,null);
        out.println("</div>");
        out.println("</td></tr>");
    }
%>
        </table>
    </fieldset>
</form>