<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*,org.semanticwb.portal.api.*"%>
<%!

    String replaceUriID(String txt)
    {
        String ret=txt;
        ret=SWBUtils.TEXT.replaceAll(ret, "swb:", URLEncoder.encode(SemanticVocabulary.URI));
        ret=SWBUtils.TEXT.replaceAll(ret, "swp:", URLEncoder.encode(SemanticVocabulary.PROCESS_URI));
        ret=SWBUtils.TEXT.replaceAll(ret, "social:", URLEncoder.encode("http://www.semanticwebbuilder.org/swb4/social#"));
        //ret=SWBUtils.TEXT.replaceAll(ret, "eng:", URLEncoder.encode("http://www.owl-ontologies.com/oqp_engine.owl#"));
        return ret;
    }    
    
    String replaceId(String id)
    {
        id=id.substring(id.lastIndexOf('/')+1);
        id=id.replace('#', ':');        
        return id;
    }

%>
<%
    User user=SWBContext.getAdminUser();
    if(user==null)
    {
        response.sendError(403);
        return;
    }
%>
<%    
    String lang="es";
    if(user!=null)lang=user.getLanguage();
    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    String id=request.getParameter("suri");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();
    SemanticObject obj=ont.getSemanticObject(id);
    WebSite adm=SWBContext.getAdminWebSite();
    //System.out.println("suri:"+id);
    if(obj==null)return;
    SemanticClass cls=obj.getSemanticClass();

    String loading="<BR/><center><img src='"+SWBPlatform.getContextPath()+"/swbadmin/images/loading.gif'/><center>";

    //Div dummy para detectar evento de carga y modificar titulo
    String icon=SWBContext.UTILS.getIconClass(obj);
    out.println("<div dojoType=\"dijit.layout.ContentPane\"  postCreate=\"setTabTitle('"+id+"','"+SWBUtils.TEXT.scape4Script(obj.getDisplayName(lang))+"','"+icon+"');\" />");

    out.println("<div dojoType=\"dijit.layout.TabContainer\" region=\"center\" id=\""+replaceId(id)+"_tab2\">");

    //TODO:Modificar este codigo para recarga de clases, posible cambio por onLoad
    out.println("    <script type=\"dojo/connect\">");
    out.println("       this.watch(\"selectedChildWidget\", function(name, oval, nval){");
%>
    require(["dijit/registry",  "dojo/on", "dojo/ready", "dojo/domReady!"], function (registry, on, ready) {               
        on(nval.controlButton, "DblClick", function (event) {
            nval.refresh();
        });           
    });
<%                
    //out.println("           onClickTab(nval);");
    out.println("       });    ");
    out.println("    </script>");
    
    Iterator<ObjectBehavior> obit=SWBComparator.sortSermanticObjects(ObjectBehavior.ClassMgr.listObjectBehaviors(adm));
    //Iterator<ObjectBehavior> obit=SWBComparator.sortSermanticObjects(new GenericIterator(ObjectBehavior.swbxf_ObjectBehavior, obj.getModel().listInstancesOfClass(ObjectBehavior.swbxf_ObjectBehavior)));

    while(obit.hasNext())
    {
        ObjectBehavior ob=obit.next();
        
        if(ob.getNsPrefixFilter()!=null)
        {
            String pf=ob.getNsPrefixFilter();
            if(SWBPlatform.getSemanticMgr().getOntology().getRDFOntModel().getNsPrefixURI(pf)==null)continue;            
        }
        //System.out.println("ob:"+ob);
        if(!ob.isVisible())continue;

        //TODO: validar esto en otra clase
        if(!SWBObjectFilter.filter(obj, ob.getPropertyFilter()))continue;

        String title=ob.getDisplayName(lang);
        if(title!=null)title=title.replace("\"", "&cuote;");
        //DisplayObject dpobj=ob.getDisplayObject();
        SemanticObject interf=ob.getInterface();
        boolean refresh=ob.isRefreshOnShow();
        //String url=ob.getParsedURL();
        String url=ob.getUrl();
        //System.out.println("ob:"+ob.getTitle(lang)+" "+ob.getDisplayObject()+" "+ob.getInterface()+" "+ob.getURL());

//        Iterator<ResourceParameter> prmit=ob.listParams();
//        while(prmit.hasNext())
//        {
//            ResourceParameter rp=prmit.next();
//            params+="&"+rp.getName()+"="+rp.getValue().getEncodedURI();
//        }
        //System.out.println("params:"+params);
        //Genericos
        
        SemanticObject robj=null;

        boolean addDiv=false;
        //if(dpobj==null)
        {
            if(interf==null)
            {
                addDiv=true;
            }else
            {
                SemanticClass scls=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(interf.getURI());
                if(scls!=null)
                {
                    if(obj.instanceOf(scls))
                    {
                        addDiv=true;
                    }else if(obj.instanceOf(Resource.sclass))
                    {
                        Resource res=(Resource)obj.createGenericInstance();
                        SWBResource swbres=SWBPortal.getResourceMgr().getResource(res);
                        if(swbres!=null && swbres instanceof GenericSemResource)
                        {
                            robj=((GenericSemResource)swbres).getSemanticObject();
                            if(robj.instanceOf(scls))
                            {
                                addDiv=true;
                            }
                        }
                    }

                }
            }
        }
        if(addDiv)
        {
            //System.out.println(SWBPortal.getAdminFilterMgr().haveAccessToSemanticObject(user, obj));
            if(!SWBPortal.getAdminFilterMgr().haveAccessToSemanticObject(user, obj))
            {
                if(!ob.getId().equals("bh_Information"))
                {
                    addDiv=false;
                }
            } else if(!SWBPortal.getAdminFilterMgr().haveAccessToWebPage(user, ob))
            {
                addDiv=false;
            }
        }
        if(addDiv)
        {
            SemanticObject aux=obj;
            if(robj!=null)aux=robj;

            String params="suri="+URLEncoder.encode(aux.getURI());

            String bp=ob.getBehaviorParams();
            if(bp!=null)
            {
                params+="&"+replaceUriID(bp);
            }

            //out.println("<div dojoType=\"dojox.layout.ContentPane\" title=\""+title+"\" _style=\"display:true;padding:10px;\" refreshOnShow=\""+refresh+"\" href=\""+url+"?"+params+"\" executeScripts=\"true\">");
            //System.out.println("url:"+url+"?"+params);
            out.println("<div id_=\""+aux.getURI()+"/"+ob.getId()+"\" dojoType=\"dijit.layout.ContentPane\" title=\""+title+"\" refreshOnShow=\""+refresh+"\" href=\""+url+"?"+params+"\" _loadingMessage=\""+loading+"\" style=\"overflow:auto;\" style_=\"border:0px; width:100%; height:100%\" onLoad_=\"onLoadTab(this);\">");
            //out.println("    <script type=\"dojo/connect\">");
            //out.println("       dojo.connect(this.controlButton, \"onClick\", onClickTab);");
            //out.println("    </script>");
            //request.getRequestDispatcher((url+"?"+params).substring(4)).include(request, response);
            out.println("</div>");
            //out.println("    <script type=\"dojo/connect\">");
            //out.println("       dojo.connect(this.controlButton, \"onClick\", onClickTab);");
            //out.println("       alert(\"hola\");");
            //out.println("    </script>");
        }
    }

    out.println("</div><!-- end Bottom TabContainer -->");   
%>