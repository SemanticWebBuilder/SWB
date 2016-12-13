<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="org.semanticwb.platform.*"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.community.*"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%><%!
private final int I_PAGE_SIZE = 20;
%>
<%
            Resource base = paramRequest.getResourceBase();
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            String perfilPath = wpage.getWebSite().getWebPage("perfil").getUrl();
            Iterator<DirectoryObject> itObjs = (Iterator) request.getAttribute("itDirObjs");
            SemanticClass cls = null;
            String lang = user.getLanguage();
            SemanticObject sobj=null;
            if(request.getParameter("sobj")==null)
            {
                sobj= (SemanticObject) request.getAttribute("sobj");
            }
            else
            {
                sobj=paramRequest.getResourceBase().getSemanticObject().getSemanticObject(request.getParameter("sobj"));
            }
            

            SWBResourceURL url = paramRequest.getRenderUrl();
            boolean toggleOrder = true;
            if(paramRequest.getCallMethod()==paramRequest.Call_STRATEGY)
            {

                SWBResourceURL urlAdd=paramRequest.getRenderUrl();                
                if("showcombo".equals(request.getParameter("mode")))
                {
                    if("Comunidades".equals(wpage.getId()))
                    {
                        wpage=wpage.getWebSite().getWebPage("Intereses");
                    }
                    StringBuffer select = new StringBuffer("");
                    StringBuffer temas = new StringBuffer("");
                    String opciones = null;
                    if(!(wpage instanceof MicroSite))
                    {
                        if(wpage.getLevel()==1)
                        {
                            //obteniendo WebPages de temas que sería el Level = 2
                            Iterator<WebPage> iteWP = wpage.listChilds(paramRequest.getUser().getLanguage(),true,false,false,true);
                            while(iteWP.hasNext())
                            {
                                WebPage wpc = iteWP.next();
                                if(!(wpc instanceof MicroSite))
                                {
                                    opciones =  getSubTemas(wpc,lang);
                                    if(opciones.trim().length()>0)
                                    {
                                        temas.append("<optgroup label=\""+wpc.getDisplayName()+"\">");
                                        temas.append(opciones);
                                        temas.append("</optgroup>");
                                    }
                                }
                            }
                            if(null!=temas&&temas.toString().trim().length()>0)
                            {
                                select.append("<select name=\"wpid\">");
                                select.append(temas);
                                select.append("</select>");
                            }

                        } else if(wpage.getLevel()==2)
                        {
                            
                            opciones = getSubTemas(wpage,lang);
                            if(null!=opciones&&opciones.trim().length()>0)
                            {
                                select.append("<select name=\"wpid\">");
                                select.append(opciones);
                                select.append("</select>");
                            }
                        }

                        if(select.toString().trim().length()==0&&wpage.getLevel()==1)
                        {
                            if(!(wpage instanceof MicroSite))
                            {
                                opciones =  getSubTemas(wpage,lang);
                            }
                            if(null!=opciones&&opciones.trim().length()>0)
                            {
                                select.append("<select name=\"wpid\">");
                                select.append(opciones);
                                select.append("</select>");
                            }
                        }
                    }
                    %>
                    <div id="opcionesHeader" class="opt3">
                        <ul class="listaOpciones">
                            <li>Seleccione la categoria para crear el elemento:
                                <form id="faddMS" action="<%=urlAdd%>" method="get">
                            <%=select.toString()%>
                            <button name="btnsubmit" type="submit">Agregar</button><button name="btnsubmit" type="button" onClick="javascript:Cancel('<%=paramRequest.getRenderUrl()%>');">Cancelar</button>
                            </form></li>
                        </ul>
                    </div>
                             <script type="text/javascript">
                    function Cancel(url)
                    {
                        window.location=url;
                    }
                    </script>
                    <%
                }
                               
            }

            
            if (sobj != null)
            {
                cls = SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(sobj.getURI());
                url.setParameter("uri", sobj.getURI());
                url.setParameter("act", "add");
%>
<div class="twoColContent">
    <div class="adminTools">
        <%if (user.isRegistered() && user.isSigned())
    {%>
        <a class="adminTool" href="<%=url.toString(true)%>">Agregar elemento al indice</a>
        <%}
    if (itObjs.hasNext())
    {%>
        <a class="adminTool" id="toggle_link" href="#" onclick="toggle('togle_div')">Mostrar Filtros</a>
        <%}%>
    </div>
    <%if (!user.isRegistered() && !user.isSigned())
    {%>
    <p><span class="tituloRojo">NOTA: </span>Debe estar registrado y haber iniciado sesi&oacute;n para poder publicar elementos.</p>
    <%}%>
    <div id="entriesList">
        <%
    //Empieza paginación
    SWBResourceURL urlPag = paramRequest.getRenderUrl();
    int actualPage = 1;
    if (request.getParameter("actualPage") != null)
    {
        actualPage = Integer.parseInt(request.getParameter("actualPage"));
    }

    //Leer parametros que se envían para filtrado
    String sparams = "";
    HashMap hdirParams = new HashMap();
    Map mParams = request.getParameterMap();
    Iterator itParams = mParams.keySet().iterator();
    while (itParams.hasNext())
    {
        String pname = (String) itParams.next();
        sparams += "&" + pname + "=" + request.getParameter(pname);
        if (pname.startsWith("swbdirParam_"))
        {
            String param = pname.substring(12);
            if (request.getParameter(param) != null)
            {
                hdirParams.put(param, request.getParameter(param));
            }
        }
    }

    //System.out.println("PARAMS SIZE:"+hdirParams.size());
    //Termina leida de parametros para filtrar
    ArrayList<DirectoryObject> alFilterTmp = new ArrayList();
    if (hdirParams.size() > 0)
    {//Se desea filtrar información en los resultados
        while (itObjs.hasNext())
        {
            ArrayList alFilter = new ArrayList();
            DirectoryObject dirObj = (DirectoryObject) itObjs.next();
            SemanticObject semObject = dirObj.getSemanticObject();
            SWBFormMgr mgr = new SWBFormMgr(semObject, null, SWBFormMgr.MODE_VIEW);
            Iterator<SemanticProperty> ipsemProps = semObject.listProperties();
            while (ipsemProps.hasNext())
            {
                SemanticProperty semProp = ipsemProps.next();
                if (semProp.isDataTypeProperty())
                {
                    String propValue = semObject.getProperty(semProp);
                    if (propValue != null && !propValue.equals("null"))
                    {
                        if (hdirParams.containsKey(semProp.getName())) //Filtrado
                        {
                            if (semProp.getName().equals("dirPhoto")) //La foto x ser de tipo text,no se puede controlar dinamicamente
                            {
                                alFilter.add(semProp.getName());
                            }
                            else if (semProp.isBoolean() && propValue.equals("true"))
                            {
                                //System.out.println("***Boolean-->semProp:"+semProp+",valor:"+propValue);
                                alFilter.add(semProp.getName());
                            }
                            else
                            {
                                FormElement element = mgr.getFormElement(semProp);
                                if (element != null && element.getId() != null)
                                {
                                    if (element.getId().indexOf("selectOne") > -1)
                                    {
                                        if (request.getParameter(semProp.getName()) != null && request.getParameter(semProp.getName()).equals(propValue))
                                        {
                                            //System.out.println("***selectOne-->semProp:"+semProp+",valor:"+propValue);
                                            alFilter.add(semProp.getName());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (hdirParams.containsKey("dirNotAbused"))
            {
                if (dirObj.getAbused() == 0)
                {
                    alFilter.add("dirNotAbused");
                }
            }
            if (alFilter.size() == hdirParams.size()) //Si el elemento cumple con todos los filtros, se agrega a los elementos a listar
            {
                alFilterTmp.add(dirObj);
            }
        }
    }
    else
    {
        sparams = "";
    }
    if (alFilterTmp.size() > 0)
    { //Si se encontraron elementos para listar en el resultado de la busqueda por filtro, seran los tomados al final
        itObjs = alFilterTmp.iterator();
    }
    //Comienza ordenamiento de elementos, por defecto se ordena por título del elemento del directorio
    Set setResult = null;
    SemanticProperty semPropOrder = DirectoryObject.swb_title;
    if (request.getParameter("orderBy") != null && request.getParameter("orderBy").equals("date"))
    {
        urlPag.setParameter("orderBy", "date");
        setResult = SWBComparator.sortByCreatedSet(itObjs, false);
    }
    else if (request.getParameter("orderBy") != null && request.getParameter("orderBy").equals("pricel"))
    {
        setResult = new TreeSet(new Comparator()
        {

            public int compare(Object o1, Object o2)
            {
                ClasifiedBuySell ob1 = (ClasifiedBuySell) o1;
                ClasifiedBuySell ob2 = (ClasifiedBuySell) o2;
                return Float.compare(ob1.getPrice(), ob2.getPrice());
            }
        });
        toggleOrder = false;
        while (itObjs.hasNext())
        {
            DirectoryObject o = itObjs.next();
            setResult.add(o);
        }
    }
    else if (request.getParameter("orderBy") != null && request.getParameter("orderBy").equals("priceh"))
    {
        setResult = new TreeSet(new Comparator()
        {

            public int compare(Object o1, Object o2)
            {
                ClasifiedBuySell ob1 = (ClasifiedBuySell) o1;
                ClasifiedBuySell ob2 = (ClasifiedBuySell) o2;
                return Float.compare(ob2.getPrice(), ob1.getPrice());
            }
        });
        toggleOrder = true;
        while (itObjs.hasNext())
        {
            DirectoryObject o = itObjs.next();
            setResult.add(o);
        }
    }
    else if (request.getParameter("orderBy") != null && request.getParameter("orderBy").equals("title"))
    {
        setResult = SWBComparator.sortByDisplayNameSet(itObjs, user.getLanguage());
    }
    else
    {
        setResult = SWBComparator.sortByCreatedSet(itObjs, false);
    }
    //Ya sabiendo cuantos y cuales son los elementos a listar (ya que puede ser una busqueda filtrada), se página
    String pagination = getPageRange(setResult.size(), actualPage);
    int iIniPage = 0;
    int iFinPage = 0;
    int iTotPage = 0;
    int contTokens = 0;
    StringTokenizer strTokens = new StringTokenizer(pagination, "|");
    while (strTokens.hasMoreTokens())
    {
        String token = strTokens.nextToken();
        contTokens++;
        if (contTokens == 1)
        {
            iIniPage = Integer.parseInt(token);
        }
        else if (contTokens == 2)
        {
            iFinPage = Integer.parseInt(token);
        }
        else if (contTokens == 3)
        {
            iTotPage = Integer.parseInt(token);
        }
    }
if (iTotPage > 1)
    {
        %><p><%
        }
    if (iTotPage > 1)
            %>Página(<%            if (actualPage > 1)
            {
                int gotop = (actualPage - 1);
                urlPag.setParameter("actualPage", "" + gotop);
            %><a class="link" href="<%=urlPag.toString(true)%><%=sparams%>"><<</a>&nbsp;<%
        }
    if (iTotPage > 1)
    {
        for (int i = 1; i <= iTotPage; i++)
        {
            if (i == actualPage)
            {
            %><strong><%=i%></strong><%;
                }
                else
                {
                    urlPag.setParameter("actualPage", "" + i);
            %><a href="<%=urlPag.toString(true)%><%=sparams%>"><%=i%></a><%
            }
        }
    }
    if (actualPage > 0 && (actualPage + 1 <= iTotPage))
    {
        int gotop = (actualPage + 1);
        urlPag.setParameter("actualPage", "" + gotop);
            %><a class="link" href="<%=urlPag.toString(true)%><%=sparams%>">>></a>&nbsp;<%
    }
    if (iTotPage > 1)
    {
            %>)
        </p>
        <%}
      SWBResourceURL urlOrder = paramRequest.getRenderUrl();
      //Termina paginación
      //Comienza criterios de busqueda y ordenamiento (x los elementos que el usuario puede filtrar en sus busquedas, dependiendo del tipo de objeto)
      String dirPhotoCheck = "";
      if (request.getParameter("dirPhoto") != null)
      {
          dirPhotoCheck = "checked";
      }

      String dirNotAbusedCheck = "";
      if (request.getParameter("dirNotAbused") != null)
      {
          dirNotAbusedCheck = "checked";
      }
        %>
        <script type="text/javascript">
            dojo.require("dojo.fx");
            dojo.require("dijit.ColorPalette");
            dojo.require("dijit.form.Button");

            function expande(oId) {
                var anim1 = dojo.fx.wipeIn( {node:oId, duration:500 });
                var anim2 = dojo.fadeIn({node:oId, duration:500});
                dojo.fx.combine([anim1,anim2]).play();
                dojo.byId('toggle_link').innerHTML = "Ocultar Filtros";
            }

            function collapse(oId) {
                var anim1 = dojo.fx.wipeOut( {node:oId, duration:500 });
                var anim2 = dojo.fadeOut({node:oId, duration:600});
                dojo.fx.combine([anim1, anim2]).play();
                dojo.byId('toggle_link').innerHTML = "Mostrar Filtros";
            }

            function toggle(oId) {
                var o = dojo.byId(oId);
                if(o.style.display=='block' || o.style.display==''){
                    collapse(oId);
                } else {
                    expande(oId);
                }
            }
        </script>

        <div id="togle_div" style="display:none">
            <form action="<%=urlOrder.setAction("filter").toString(true)%>" method="post">
                <fieldset ><legend>Filtrar por</legend>
                    <input type="hidden" name="swbdirParam_dirNotAbused" value="1"/>
                    <input type="hidden" name="swbdirParam_dirPhoto" value="1"/>
                    Solo anuncios con foto  &nbsp;<input type="checkbox" name="dirPhoto" <%=dirPhotoCheck%> />

                    <br/>
                    Solo apropiados  &nbsp; &nbsp; &nbsp; &nbsp;<input type="checkbox" name="dirNotAbused" <%=dirNotAbusedCheck%> />

                    <br/>
                    <%
                    SWBFormMgr mgr = new SWBFormMgr(cls, wpage.getSemanticObject(), null);
                    mgr.setFilterRequired(false);
                    Iterator<SemanticProperty> itProps=cls.listProperties();
                    while(itProps.hasNext()){
                         SemanticProperty semProp1=itProps.next();
                         if(semProp1.isBoolean()){
                            %>
                            <%=semProp1.getDisplayName(user.getLanguage())%>  <%=mgr.renderElement(request, semProp1,mgr.MODE_CREATE)%>
                                <input type="hidden" name="swbdirParam_<%=semProp1.getName()%>" value="1" />
                            <br/>
                            <%
                          }
                          FormElement element=mgr.getFormElement(semProp1);
                          if(element!=null && element.getId()!=null){
                            if(element.getId().indexOf("selectOne")>-1){
                                mgr.setType(mgr.TYPE_XHTML);
                                %>
                                 <%=semProp1.getDisplayName(user.getLanguage())%>&nbsp;<%=mgr.renderElement(request, semProp1,mgr.MODE_CREATE)%>
                                <input type="hidden" name="swbdirParam_<%=semProp1.getName()%>" value="1" />
                                <br/>
                               <%
                               continue;
                            }
                         }
                    }
                    %>
                    <input type="submit" value="Filtrar" /><br/>
                </fieldset>
            </form>
        </div> 
        <%if (setResult.iterator().hasNext())
    {%>
        <p style="text-align:right">Ordenar por
            <%if (cls.equals(ClasifiedBuySell.sclass))
    {
        if (toggleOrder)
        {
            %>
            <a href="<%=urlOrder.setParameter("orderBy", "pricel")%>">menor precio</a> |
            <%
            }
            else
            {
            %>
            <a href="<%=urlOrder.setParameter("orderBy", "priceh")%>">mayor precio</a> |
            <%
    }
}
            %>
            <a href="<%=urlOrder.setParameter("orderBy", "title")%>">nombre</a> | <a href="<%=urlOrder.setParameter("orderBy", "date")%>">fecha</a>
        </p>
        <%}%>
        <!--Termina desplagado de criterios (filtros) de busqueda-->
        <%
    //Comienza Desplegado de elementos filtrados (si aplica) y ordenados
    SWBResourceURL urlDetail = paramRequest.getRenderUrl();
    SWBResourceURL urlEdit = paramRequest.getRenderUrl();
    SWBResourceURL urlRemove = paramRequest.getRenderUrl();

    urlDetail.setParameter("act", "detail");
    urlEdit.setParameter("act", "edit");
    urlRemove.setParameter("act", "detail");

    int cont = 0;
    boolean exist = false;
    HashMap map = new HashMap();
    map.put("separator", "-");
    Iterator itResult = setResult.iterator();
    while (itResult.hasNext())
    {
        cont++;
        DirectoryObject dirObj = (DirectoryObject) itResult.next();
        if (cont <= iIniPage)
        {
            continue;
        }
        else if (cont > iFinPage)
        {
            break;
        }
        exist = true;
        String img = "", title = "", description = "", tags = "", price = null, creator = "", created = "";
        String claimerUrl = "";
        urlDetail.setParameter("uri", dirObj.getURI());
        urlEdit.setParameter("uri", dirObj.getURI());
        urlRemove.setParameter("uri", dirObj.getURI());
        User userObj = null;
        User claimer = null;
        SemanticObject semObject = dirObj.getSemanticObject();
        Iterator<SemanticProperty> ipsemProps = semObject.listProperties();
        while (ipsemProps.hasNext())
        {
            SemanticProperty semProp = ipsemProps.next();
            if (semProp.isDataTypeProperty())
            {
                String propValue = semObject.getProperty(semProp);
                if (propValue != null && !propValue.equals("null"))
                {
                    if (semProp == DirectoryObject.swbcomm_dirPhoto)
                    {
                        img = "<img alt=\"\" src=\"" + SWBPortal.getWebWorkPath() + "/" + semObject.getWorkPath() + "/" + propValue + "\" width=\"90\" height=\"90\" />";
                    }
                    if (semProp == DirectoryObject.swb_title)
                    {
                        title = propValue;
                    }
                    else if (semProp == DirectoryObject.swb_description)
                    {
                        description = propValue;
                    }
                    else if (semProp == DirectoryObject.swb_tags)
                    {
                        tags = propValue;
                    }
                    else if (semProp == ClasifiedBuySell.swbcomm_Price)
                    {
                        price = propValue;
                    }
                    else if (semProp == DirectoryObject.swb_created)
                    {
                        Date date = semObject.getDateProperty(semProp);
                        created = SWBUtils.TEXT.getTimeAgo(date, user.getLanguage());
                    }
                }
            }
            else if (semProp == DirectoryObject.swb_creator)
            {
                SemanticObject semUser = semObject.getObjectProperty(DirectoryObject.swb_creator);
                if (semUser != null)
                {
                    userObj = (User) semUser.createGenericInstance();
                    creator = "<a href=\"" + perfilPath + "?user=" + userObj.getEncodedURI() + "\">" + userObj.getFullName() + "</a>";
                }
            }
        }

        if (dirObj.isClaimed())
        {
            SemanticObject claimerUsr = semObject.getObjectProperty(Claimable.swbcomm_claimer);
            if (claimerUsr != null)
            {
                claimer = (User) claimerUsr.createGenericInstance();
                claimerUrl = perfilPath + "?user=" + claimer.getEncodedURI();
            }
        }
        %>
        <div class="listEntry" onmouseover="this.className='listEntryHover'" onmouseout="this.className='listEntry'">
            <%if (!img.equals(""))
             {%><%=img%><%}
else
{%><img alt="Imagen no disponible" src="<%=SWBPortal.getContextPath()%>/swbadmin/images/noDisponible.gif" /><%}%>
            <div class="listEntryInfo">
                <p class="tituloRojo">
                    <%=title%>
                </p>
                <p>
                    <%=description%>
                </p><br/>
                <%if (price != null && price.trim().length() > 0 && !price.equals("null"))
             {%><p><span class="itemTitle">Precio: </span><%=price%></p><%}%>
                <%if (!tags.trim().equals(""))
             {%><p><span class="itemTitle">Palabras clave: </span><%=tags%></p><%}%>
                <p><span class="itemTitle">Creado por: </span><%=creator%>, <%=created%></p>
                <%
             if (claimer != null)
             {%>
                <p><b><font color="#B40000">Este elemento ha sido reclamado por <a href="<%=claimerUrl%>"><%=claimer.getFullName()%></a></font></b></p><%
         }
                %>
                <p class="vermas">
                    <%
         if (user.isRegistered() && user.isSigned())
         {
             UserGroup group = user.getUserRepository().getUserGroup("admin");
             if ((userObj != null && userObj.getURI().equals(user.getURI())) || group != null && user.hasUserGroup(group))
             {
                    %>
                    <a href="<%=urlEdit.toString(true)%>">Editar</a>&nbsp;|&nbsp;<a href="<%=urlRemove.setAction(urlRemove.Action_REMOVE)%>"><%=paramRequest.getLocaleString("remove")%></a>&nbsp;|&nbsp;
                    <%  }
         }
                    %>
                    <a href="<%=urlDetail.toString(true)%>"><%=paramRequest.getLocaleString("seeMore")%></a>
                </p>
                <div class="clear">&nbsp;</div>
            </div>
        </div>
        <%
}
if (!exist)
{
        %>
        <div class="listEntry" onmouseover="this.className='listEntryHover'" onmouseout="this.className='listEntry'">
            <img src="<%=SWBPortal.getContextPath()%>/swbadmin/images/anunciate.gif" alt="Anunciate"></img>
            <div class="listEntryInfo">
                <p class="tituloRojo">
                    Título de tu anuncio
                </p>
                <p>
                    Descripci&oacute;n de tu anuncio
                </p><br/>
                <p><span class="itemTitle">Palabras clave: </span>Palabras clave</p>
                <p><span class="itemTitle">Creado por: </span>Tu nombre aquí</p>

                
                <%-- <p class="vermas"><%=paramRequest.getLocaleString("seeMore")%></p> --%>
                
                <div class="clear">&nbsp;</div>
            </div>
        </div>
        <%
}
        %>
    </div>
</div>
<%
            }
            
%>

<%!
    //Función utilizada para manejo de paginación
    private String getPageRange(int iSize, int iPageNum) {
        int iTotPage = 0;
        int iPage = 1;
        if (iPageNum > 1) {
            iPage = iPageNum;
        }
        if (iSize > I_PAGE_SIZE) {
            iTotPage = iSize / I_PAGE_SIZE;
            int i_ret = iSize % I_PAGE_SIZE;
            if (i_ret > 0) {
                iTotPage = iTotPage + 1;
            }
        } else {
            iTotPage = 1;
        }
        int iIniPage = (I_PAGE_SIZE * iPage) - I_PAGE_SIZE;
        int iFinPage = I_PAGE_SIZE * iPage;
        if (iSize < I_PAGE_SIZE * iPage) {
            iFinPage = iSize;
        }
        return iIniPage + "|" + iFinPage + "|" + iTotPage;
    }
%>

<%!
    public String getSubTemas(WebPage wp, String lang)
    {
        StringBuffer stOpts = new StringBuffer("");
        // obteniendo el listado de subtemas
        Iterator<WebPage> itwpst = wp.listChilds(lang,true,false,false,true);
        while(itwpst.hasNext())
        {
            WebPage wpst = itwpst.next();
            if(!(wpst instanceof MicroSite))
            {
               stOpts.append("<option label=\""+wpst.getDisplayName()+"\">"+wpst.getId()+"</option>");
            }
        }
        return stOpts.toString();
    }
%>