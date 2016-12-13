<%@page import="org.semanticwb.model.SWBVocabulary"%>
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
    String act=request.getParameter("act");
    if(act==null) act="";

    String pathView=SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp";
    String actform = SWBPlatform.getContextPath()+"/swbadmin/jsp/classDomain.jsp";

    //out.println(suri+" "+Thread.currentThread().getName());
    //SemanticOntology ont=(SemanticOntology)session.getAttribute("ontology");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getSchema();

    SemanticClass cls=new SemanticClass(ont.getRDFOntModel().getOntClass(suri));


    if(act.equals("addnewprop"))
    {

        //st = m.createStatement(res, m.getProperty(SemanticVocabulary.RDF_TYPE), m.getResource(SemanticVocabulary.OWL_CLASS));

    } else if(act.equals("newprop"))
    {
        //out.println("Nueva propiedad para la clase");
        out.println("<form id=\"\" action=\""+actform+"\">");
        out.println("<input type=\"hidden\" name=\"suri\" value=\""+suri+"\">");
        out.println("<input type=\"hidden\" name=\"act\" value=\"addnewprop\">");
        out.println("<div>");
        out.println("<label for=\"_pname\">Property name:</label><input type=\"text\" name=\"_pname\"><br/>");
        out.println("<label for=\"_stype\">Property type:</label><select name=\"_stype\">");
        out.println("   <option value=\"0\">Select prop type</option>");
        SemanticClass clsprop=new SemanticClass(ont.getRDFOntModel().getOntClass(SWBPlatform.getSemanticMgr().getVocabulary().RDF_PROPERTY));
        //OntClass ontcls=ont.getRDFOntModel().getOntClass(SWBPlatform.getSemanticMgr().getVocabulary().RDF_PROPERTY);

        //Iterator<OntProperty> itontprop = ontcls.listDeclaredProperties();
        Iterator<SemanticProperty> it = clsprop.listProperties();
        while (it.hasNext())
        {
            SemanticProperty semprop = it.next();
            out.println("   <option value=\""+semprop.getURI()+"\">"+semprop.getPropId()+"</option>");
        }
        
        out.println("</select><br/><br/>");
        out.println("<button dojoType=\"dijit.form.Button\" type=\"button\"><span>Add</span>");
        out.println("<script type=\"dojo/method\" event=\"onClick\">");
        //out.println("   submit();");
        out.println("   hideDialog();return false;");
        out.println("</script>");
        out.println("</button>");
        out.println("<button dojoType=\"dijit.form.Button\" type=\"button\"><span>Cancel</span>");
        out.println("<script type=\"dojo/method\" event=\"onClick\">");
        out.println("   hideDialog();return false;");
        out.println("</script>");
        out.println("</button>");
        out.println("</div");
        out.println("</form>");

    }
    else if(act.equals("removeprops"))
    {
        System.out.println("Eliminando propiedades de la clase");
        String[] vals = request.getParameterValues("propuri");
        if(vals!=null)
        {
            for(int i=0; i<vals.length;i++)
            {
                System.out.println("Quitar puri: "+vals[i]);
            }
        }

    }
    if(!act.equals("newprop"))
    {

%>
<form dojoType="dijit.form.Form" id="<%=suri%>_addremprop" name="<%=suri%>_addremprop" method="post" action="<%=actform%>">
        <input type="hidden" name="suri" value="<%=suri%>">
        <input type="hidden" name="act" value="">
    <table width="100%">
        <thead>
            <tr>
                <th>&nbsp;</th>
                <th>Propiedad</th>
                <th>Tipo</th>
                <th>Rango</th>
                <th>Dominio</th>
                <th>
                    <button dojoType="dijit.form.Button" type="button">
                        <span>+</span>
                        <script type="dojo/method" event="onClick">
                            showDialog('<%=SWBPlatform.getContextPath()%>/swbadmin/jsp/classDomain.jsp?act=newprop&suri=<%=URLEncoder.encode(suri)%>','Nueva propiedad');
                        </script>
                    </button>
                    <button dojoType="dijit.form.Button" type="button">
                        <span>-</span>
                        <script type="dojo/method" event="onClick" >
                            if(confirm('Estas seguro de quere eliminar las propiedades seleccionadas?'))
                            {
                                var forma = dijit.byId('<%=suri%>_addremprop').domNode;
                                forma.act.value='removeprops';
                                forma.submit();
                            }
                            return false;
                        </script>
                    </button>
                </th>
            </tr>
        </thead>
    <tbody>
<%
    Property ptype=ont.getRDFOntModel().getProperty(SemanticVocabulary.RDF_TYPE);
    Iterator<SemanticProperty> itp=org.semanticwb.model.SWBComparator.sortSermanticProperties(cls.listProperties());
    //Iterator<Property> itp=cls.getOntClass().listDeclaredProperties();
    while(itp.hasNext())
    {
        SemanticProperty prop=itp.next();
        SemanticClass dom=prop.getDomainClass();
        //if(dom!=null)
        if(dom!=null && (dom.equals(cls) || dom.isSuperClass(cls)))
        {
            //Buscar Tipo
            String type=SWBPlatform.JENA_UTIL.getObjectLink(prop.getRDFProperty(), ptype, ont.getRDFOntModel(), pathView);

            //Buscar Rango
            String rang="";
            SemanticClass rcls=prop.getRangeClass();
            if(rcls!=null)
            {
                rang=SWBPlatform.JENA_UTIL.getLink(rcls.getOntClass(), pathView);
                //rang=rcls.getPrefix()+":"+rcls.getName();
            }else
            {
                if(prop.getRange()!=null)
                {
                    rang=SWBPlatform.JENA_UTIL.getLink(prop.getRange(), pathView);
                    //rang=ont.getRDFOntModel().getNsURIPrefix(prop.getRange().getNameSpace())+":"+prop.getRange().getLocalName();
                }
            }

            boolean direct=dom.equals(cls);
            String style="style=\"font-weight: lighter;\"";

            String domin=SWBPlatform.JENA_UTIL.getLink(dom.getOntClass(), pathView);

            if(direct)style="style=\"font-weight: bolder; background-color: #f0f0ff;\"";
            out.print("<tr>");
            if(direct) out.print("<td "+style+"><input type=\"checkbox\" value=\""+prop.getURI()+"\" name=\"propuri\"></td>");
            else out.print("<td "+style+">&nbsp;</td>");
            out.print("<td "+style+">"+SWBPlatform.JENA_UTIL.getLink(prop.getRDFProperty() ,pathView)+"</td>");
            out.print("<td "+style+">"+type+"</td>");
            out.print("<td "+style+">"+rang+"</td>");
            out.print("<td colspan=\"2\" " +style+">"+domin+"</td>");
            out.println("</tr>");
        }
    }
%>
    </tbody>
    </table>
    </form>
<%
    }

%>