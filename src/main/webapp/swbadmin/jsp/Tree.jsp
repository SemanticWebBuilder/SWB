<%@page import="java.util.ArrayList"%>
<%@page import="com.hp.hpl.jena.ontology.OntModelSpec"%>
<%@page import="com.hp.hpl.jena.ontology.OntDocumentManager"%>
<%@page import="com.hp.hpl.jena.ontology.OntProperty"%>
<%@page import="com.hp.hpl.jena.ontology.OntClass"%>
<%@page import="org.json.*,org.semanticwb.*,org.semanticwb.model.*,org.semanticwb.platform.*,java.util.*,com.hp.hpl.jena.*,com.hp.hpl.jena.util.*,com.hp.hpl.jena.rdf.model.Model" %>
<%@page contentType="text/html" %><%@page pageEncoding="UTF-8" %>
<%!
    int nullnode=0;

    public String getLocaleString(String key, String lang)
    {
        String ret="";
        if(lang==null)
        {
            ret=SWBUtils.TEXT.getLocaleString("locale_swb_admin", key);
        }else
        {
            ret=SWBUtils.TEXT.getLocaleString("locale_swb_admin", key, new Locale(lang));
        }
        //System.out.println(key+" "+lang+" "+ret);
        return ret;
    }

    public synchronized SemanticOntology getOntology(HttpSession session)
    {
        //System.out.println("getOntology");
        SemanticOntology sont=(SemanticOntology)session.getAttribute("ontology");
        if(sont==null)
        {
            OntDocumentManager mgr=com.hp.hpl.jena.ontology.OntDocumentManager.getInstance();
            //Model m=SWBPlatform.getSemanticMgr().loadRDFFileModel("file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/swb.owl");
            //mgr.addModel("http://www.semanticwebbuilder.org/swb4/ontology", m);

            //System.out.println("file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/owl.owl");

            //mgr.addAltEntry("http://www.w3.org/2002/07/owl", "file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/owl.owl");
            mgr.addAltEntry("http://www.semanticwebbuilder.org/swb4/ontology", "file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/swb.owl");
            mgr.addAltEntry("http://www.semanticwebbuilder.org/swb4/process", "file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl_ext/swp.owl");
            mgr.addAltEntry("http://www.semanticwebbuilder.org/swb4/community", "file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/community.owl");

            //String swbowl="file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/cat.owl";
            //java.io.File owlf=new java.io.File(swbowl);
            //SemanticModel base=SWBPlatform.getSemanticMgr().readRDFFile(owlf.getName(),swbowl);
            //sont=new SemanticOntology("", com.hp.hpl.jena.rdf.model.ModelFactory.createOntologyModel(OntModelSpec.OWL_MEM_RDFS_INF,base.getRDFModel()));
            //sont=new SemanticOntology("", mgr.getOntology("http://www.semanticwb.org/catalogs", OntModelSpec.OWL_MEM_RDFS_INF));
            //sont=new SemanticOntology("", mgr.getOntology("http://www.semanticwebbuilder.org/swb4/ontology", OntModelSpec.OWL_MEM_RDFS_INF));
            //sont.getRDFOntModel().addLoadedImport("http://www.w3.org/2002/07/owl");
            //sont.getRDFOntModel().addSubModel(mgr.getModel("http://www.w3.org/2002/07/owl"), true);
            sont=new SemanticOntology("", mgr.getOntology("http://www.semanticwebbuilder.org/swb4/process", OntModelSpec.OWL_LITE_MEM_RDFS_INF));
    /*
            swbowl="file:"+SWBUtils.getApplicationPath()+"/WEB-INF/owl/swb.owl";
            owlf=new java.io.File(swbowl);
            SemanticModel model=SWBPlatform.getSemanticMgr().readRDFFile(owlf.getName(),swbowl);
            sont.addSubModel(model, false);
    */
            session.setAttribute("ontology", sont);

            //System.out.println("Base:"+base.getRDFModel().size());
            //System.out.println("SWB:"+model.getRDFModel().size());
            //System.out.println("Ont:"+sont.getRDFOntModel().size());
        }
        return sont;
    }

    public JSONObject getAction(String name, String value, String target) throws JSONException
    {
        JSONObject obj=new JSONObject();
        obj.put("id", "_NOID_"+(nullnode++));
        obj.put("name", name);
        obj.put("value", value);
        obj.put("target", target);
        return obj;
    }

    public JSONObject getEvent(String name, JSONObject action) throws JSONException
    {
        JSONObject obj=new JSONObject();
        obj.put("id", "_NOID_"+(nullnode++));
        obj.put("name", name);
        obj.put("action", action);
        return obj;
    }

    public JSONObject getMenuItem(String title, String icon, JSONObject action) throws JSONException
    {
        JSONObject obj=new JSONObject();
        obj.put("id", "_NOID_"+(nullnode++));
        obj.put("title", title);
        obj.put("icon", icon);
        obj.put("action", action);
        return obj;
    }

    public JSONObject getNode(String id, String title, String type, String icon) throws JSONException
    {
        if(title==null)title="Topic";
        JSONObject obj=new JSONObject();
        obj.put("id", id);
        obj.put("title",title);
        obj.put("type",type);
        obj.put("icon",icon);
        return obj;
    }

    public JSONObject getDummyNode() throws JSONException
    {
        return getNode("_NOID_" + (nullnode++), "DUMMY", "DUMMY", "DUMMY");
    }

    public JSONObject getReloadAction() throws JSONException
    {
        return getAction("reload",null,null);
    }

    public JSONObject getNewTabAction() throws JSONException
    {
        return getAction("newTab",SWBPlatform.getContextPath()+"/swbadmin/jsp/objectTab.jsp",null);
    }

    public JSONObject getMenuSeparator() throws JSONException
    {
        return getMenuItem("_",null, null);
    }

    public JSONObject getMenuReload(String lang) throws JSONException
    {
        return getMenuItem(getLocaleString("reload",lang), getLocaleString("icon_reload",null), getReloadAction());
    }
    
    public void addWebSites(JSONArray arr, User user)  throws JSONException
    {
        //System.out.println("addWebSites");
        Iterator<WebSite> it=SWBComparator.sortSermanticObjects(user.getLanguage(), SWBContext.listWebSites());
        while(it.hasNext())
        {
            WebSite site=it.next();
            if(!site.isDeleted())
            {
                //System.out.println("site:"+site);
                //TODO: arreglar lista de sitios en SWBContext (estal ligados a ontologia)
                //site=SWBContext.getWebSite(site.getURI());
                addSemanticObject(arr, site.getSemanticObject(),false,true,user);
                //addWebSite(arr, site);
            }
        }

    }

    public void addUserReps(JSONArray arr, User user)  throws JSONException
    {
        //System.out.println("addWebSites");
        Iterator<UserRepository> it=SWBComparator.sortSermanticObjects(user.getLanguage(), SWBContext.listUserRepositories());
        while(it.hasNext())
        {
            UserRepository rep=it.next();
            //TODO: arreglar lista de sitios en SWBContext (estal ligados a ontologia)
            //rep=SWBContext.getUserRepository(rep.getURI());
            addSemanticObject(arr, rep.getSemanticObject(),false,true,user);
            //addWebSite(arr, site);
        }
    }

    public void addOntologies(JSONArray arr, User user)  throws JSONException
    {
        //System.out.println("addWebSites");
        Iterator<Ontology> it=SWBComparator.sortSermanticObjects(user.getLanguage(), SWBContext.listOntologies());
        while(it.hasNext())
        {
            Ontology ont=it.next();
            //TODO: arreglar lista de sitios en SWBContext (estal ligados a ontologia)
            //rep=SWBContext.getUserRepository(rep.getURI());
            addSemanticObject(arr, ont.getSemanticObject(),false,true,user);
            //addWebSite(arr, site);
        }
    }

    public void addDocRepositories(JSONArray arr, User user)  throws JSONException
    {
        //System.out.println("addWebSites");
        Iterator<org.semanticwb.repository.Workspace> it=SWBComparator.sortSermanticObjects(user.getLanguage(), SWBContext.listWorkspaces());
        while(it.hasNext())
        {
            org.semanticwb.repository.Workspace rep=it.next();
            //TODO: arreglar lista de sitios en SWBContext (estal ligados a ontologia)
            //rep=SWBContext.getUserRepository(rep.getURI());
            addSemanticObject(arr, rep.getSemanticObject(),false,true,user);
            //addWebSite(arr, site);
        }
    }

    public void addFavorites(JSONArray arr, User user)  throws JSONException
    {
        //System.out.println("user uri:"+user.getURI());
        if(user!=null && user.getURI()!=null)
        {
            UserFavorite fav=user.getUserFavorite();
            if(fav!=null)
            {
                //System.out.println("user fav:"+user.getURI());
                Iterator<SemanticObject> it=SWBComparator.sortSermanticObjects(fav.listObjects());
                while(it.hasNext())
                {
                    SemanticObject obj=it.next();
                    addSemanticObject(arr, obj,false,true,user);
                }
            }
        }
    }

    public void addWebSitesTrash(JSONArray arr, User user)  throws JSONException
    {
        Iterator<WebSite> it=SWBComparator.sortSermanticObjects(user.getLanguage(), SWBContext.listWebSites());
        while(it.hasNext())
        {
            WebSite site=it.next();
            if(!site.isDeleted())
            {
                Iterator<Resource> itp = site.listResources();
                while(itp.hasNext())
                {
                    Resource por = itp.next();
                    if(por.isDeleted())
                    {
                        addSemanticObject(arr, por.getSemanticObject(),false,true,user);
                    }
                }
                Iterator<WebPage> itwp = site.listWebPages();
                while(itwp.hasNext())
                {
                    WebPage wp = itwp.next();
                    //if(wp.getId().equals("y")) wp.setDeleted(true);
                    if(wp.isDeleted())  //wp.isDeleted()
                    {
                        addSemanticObject(arr, wp.getSemanticObject(),false,true,user);
                    }
                }
            }
        }

        it=SWBComparator.sortSermanticObjects(user.getLanguage(), SWBContext.listWebSites());
        while(it.hasNext())
        {
            WebSite site=it.next();
            if(site.isDeleted())
            {
                addSemanticObject(arr, site.getSemanticObject(),false,true,user);
            }
        }
    }

    public boolean hasHerarquicalNodes(SemanticObject obj, String lang) throws JSONException
    {
        boolean ret=false;
        Iterator<SemanticObject> it=obj.getSemanticClass().listHerarquicalNodes();
        if(it.hasNext())
        {
            ret=true;
        }
        return ret;
    }


    public void addHerarquicalNodes(JSONArray arr, SemanticObject obj, User user) throws JSONException
    {
        Iterator<SemanticObject> it=SWBComparator.sortSortableObject(obj.getSemanticClass().listHerarquicalNodes());
        while(it.hasNext())
        {
            HerarquicalNode node=new HerarquicalNode(it.next());
            addHerarquicalNode(arr,node,obj,false,user);
        }
    }

    public void addHerarquicalNode(JSONArray arr, HerarquicalNode node, SemanticObject obj, boolean addChilds, User user) throws JSONException
    {
        if(!SWBPortal.getAdminFilterMgr().haveAccessToHerarquicalNode(user, obj.getURI(), node))return;
        if(obj.getBooleanProperty(Trashable.swb_deleted)==true)return;

        if(node.getId().equals("hn_Classes"))
        {
            addHNClasses(arr, node, obj, addChilds, user);
            return;
        }else if(node.getId().equals("hn_Properties"))
        {
            addHNProperties(arr, node, obj, addChilds, user);
            return;
        }

        SemanticClass cls=null;
        if(node.getHClass()!=null)cls=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(node.getHClass().getURI());
        String pf=node.getPropertyFilter();
        JSONObject jobj=getNode("HN|"+obj.getURI()+"|"+node.getURI(), node.getDisplayTitle(user.getLanguage()), "HerarquicalNode", node.getIconClass());
        arr.put(jobj);

        JSONArray childs=new JSONArray();

        Iterator<SemanticObject> it=null;
        if(cls!=null)
        {
            it=SWBObjectFilter.filter(SWBComparator.sortSermanticObjects(user.getLanguage(), obj.getModel().listInstancesOfClass(cls)),pf);
        }else
        {
            it=new ArrayList().iterator();
        }

        //System.out.println("obj:"+obj.getId()+" cls:"+cls);
        //drop acceptance
        JSONArray dropacc=new JSONArray();
        jobj.putOpt("dropacc", dropacc);

        //Menus
        JSONArray menus=new JSONArray();
        jobj.putOpt("menus", menus);
        String url=SWBPlatform.getContextPath();

        if(cls!=null)
        {
            //TODO:Separar en controller
            if(cls.equals(Language.sclass))
            {
                url+="/swbadmin/jsp/addLang.jsp";
            }else if(cls.equals(Country.sclass))
            {
                url+="/swbadmin/jsp/addCountry.jsp";
            }else
            {
                url+="/swbadmin/jsp/SemObjectEditor.jsp";
            }
            url+="?scls="+cls.getEncodedURI()+"&sref="+obj.getEncodedURI();
            if(pf!=null)url+="&"+pf;

            if(SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_ADD))
            {
                menus.put(getMenuItem(getLocaleString("add",user.getLanguage())+" "+cls.getDisplayName(user.getLanguage()), getLocaleString("icon_add",null),getAction("showDialog", url,getLocaleString("add",user.getLanguage())+" "+cls.getDisplayName(user.getLanguage()))));
                dropacc.put(cls.getClassId());
            }
            //Iterator<SemanticClass> it2=cls.listSubClasses();
            //while(it2.hasNext())
            //{
            //    SemanticClass scls=it2.next();
            //    menus.put(getMenuItem("Agregar "+scls.getDisplayName(lang), getLocaleString("icon_add",null),getAction("showDialog", SWBPlatform.getContextPath()+"/swbadmin/jsp/SemObjectEditor.jsp?scls="+scls.getEncodedURI()+"&sref="+obj.getEncodedURI()+"&sprop="+prop.getEncodedURI(),null)));
            //    dropacc.put(scls.getClassID());
            //}
            menus.put(getMenuSeparator());
        }
        menus.put(getMenuReload(user.getLanguage()));

        SemanticProperty herarprop=null;   //Herarquical property;
        //System.out.println(cls);
        if(cls!=null)
        {
            Iterator<SemanticProperty> hprops=cls.listInverseHerarquicalProperties();
            while(hprops.hasNext())
            {
                herarprop=hprops.next();
                //System.out.println("herarprop1:"+herarprop);
            }
        }
        //System.out.println("herarprop:"+herarprop);

        if(addChilds)
        {
            Iterator<HerarquicalNode> sit=SWBComparator.sortSortableObject(node.listHerarquicalNodes());
            while(sit.hasNext())
            {
                HerarquicalNode cnode=sit.next();
                //System.out.println("cnode:"+cnode);
                addHerarquicalNode(childs,cnode,obj,false,user);
            }

            while(it.hasNext())
            {
                SemanticObject so=it.next();
                if(herarprop!=null)
                {
                    if(so.getObjectProperty(herarprop)==null)
                    {
                        addSemanticObject(childs, so,false,user);
                        //System.out.println("so1:"+so);
                    }
                }else
                {
                    addSemanticObject(childs, so,false,user);
                    //System.out.println("so2:"+so);
                }
            }
        }else
        {
            //Tiene HN
            Iterator<HerarquicalNode> sit=node.listHerarquicalNodes();

            if(it.hasNext() || sit.hasNext())
            {
                jobj.put("hasChilds", "true");
                JSONArray events=new JSONArray();
                jobj.putOpt("events", events);
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }

    //TODO:Separar en una clase treeController
    public void addResourceType(JSONArray arr, SemanticObject obj, boolean addChilds, boolean addDummy, User user) throws JSONException
    {
        if(!SWBPortal.getAdminFilterMgr().haveTreeAccessToSemanticObject(user, obj))return;
        if(obj.getBooleanProperty(Trashable.swb_deleted)==true)return;
        
        String lang=user.getLanguage();
        boolean hasChilds=false;
        SemanticClass cls=obj.getSemanticClass();
        String type=cls.getClassId();
        ResourceType restype=(ResourceType)obj.createGenericInstance();

        //Active
        boolean active=false;
        SemanticProperty activeprop=cls.getProperty("active");
        if(activeprop!=null)
        {
            active=obj.getBooleanProperty(activeprop);
        }

        String icon=SWBContext.UTILS.getIconClass(obj);
        JSONObject jobj=getNode(obj.getURI(), obj.getDisplayName(lang), type, icon);
        arr.put(jobj);

        //dragSupport
        DisplayObject dp=DisplayObject.getDisplayObject(cls);
        if(dp!=null)
        {
            jobj.put("dragSupport", dp.isDragSupport());
            jobj.put("dropMatchLevel", dp.getDropMatchLevel());
        }

        //System.out.println("obj:"+obj.getId());
        //drop acceptance
        JSONArray dropacc=new JSONArray();
        jobj.putOpt("dropacc", dropacc);

        //menus
        JSONArray menus=new JSONArray();
        jobj.putOpt("menus", menus);

        if(restype.getResourceMode()!=1)
        {
            Iterator<SemanticProperty> pit=cls.listHerarquicalProperties();
            while(pit.hasNext())
            {
                SemanticProperty prop=pit.next();
                SemanticClass rcls=prop.getRangeClass();
                if(SWBPortal.getAdminFilterMgr().haveClassAction(user, rcls, AdminFilter.ACTION_ADD))
                {
                    menus.put(getMenuItem(getLocaleString("add",lang)+" "+rcls.getDisplayName(lang), getLocaleString("icon_add",null),getAction("showDialog", SWBPlatform.getContextPath()+"/swbadmin/jsp/SemObjectEditor.jsp?scls="+rcls.getEncodedURI()+"&sref="+obj.getEncodedURI()+"&sprop="+prop.getEncodedURI(),getLocaleString("add",lang)+" "+rcls.getDisplayName(lang))));
                    dropacc.put(rcls.getClassId());
                }
            }
            menus.put(getMenuSeparator());
        }

        //Active
        if(SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_ACTIVE))
        {
            if(activeprop!=null)
            {
                if(!active)
                {
                    menus.put(getMenuItem(getLocaleString("active",lang), getLocaleString("icon_active",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/active.jsp?suri="+obj.getEncodedURI()+"&act=active",null)));
                }else
                {
                    menus.put(getMenuItem(getLocaleString("unactive",lang), getLocaleString("icon_unactive",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/active.jsp?suri="+obj.getEncodedURI()+"&act=unactive",null)));
                }
            }
        }

        if(SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_EDIT))
        {
            menus.put(getMenuItem(getLocaleString("edit",lang), getLocaleString("icon_edit",null), getNewTabAction()));
        }
        if(SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_DELETE))
        {
            if(!obj.instanceOf(Undeleteable.swb_Undeleteable) ||  (obj.instanceOf(Undeleteable.swb_Undeleteable) && obj.getBooleanProperty(Undeleteable.swb_undeleteable)==false))
            {
                menus.put(getMenuItem(getLocaleString("delete",lang), getLocaleString("icon_delete",null), getAction("showStatusURLConfirm",SWBPlatform.getContextPath()+"/swbadmin/jsp/delete.jsp?suri="+obj.getEncodedURI(),getLocaleString("delete",lang)+" "+cls.getDisplayName(lang))));
            }
        }
        menus.put(getMenuSeparator());

        boolean isfavo=user.hasFavorite(obj);
        if(!isfavo)
        {
            menus.put(getMenuItem(getLocaleString("addFavorites",lang), getLocaleString("icon_addFavorites",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=active",null)));
        }else
        {
            menus.put(getMenuItem(getLocaleString("deleteFavorites",lang), getLocaleString("icon_deleteFavorites",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=unactive",null)));
        }
        menus.put(getMenuReload(lang));

        //eventos
        JSONArray events=new JSONArray();
        jobj.putOpt("events", events);
        events.put(getEvent("onDblClick", getAction("newTab", SWBPlatform.getContextPath()+"/swbadmin/jsp/objectTab.jsp", null)));
        events.put(getEvent("onClick", getAction("getHtml", SWBPlatform.getContextPath()+"/swbadmin/jsp/viewProps.jsp?id="+obj.getEncodedURI(), "vprop")));

        //hijos
        JSONArray childs=new JSONArray();

        if(restype.getResourceMode()!=restype.MODE_CONTENT)
        {
            hasChilds=hasHerarquicalNodes(obj,lang);
            if(addChilds || !hasChilds)
            {
                addHerarquicalNodes(childs, obj,user);

                Iterator<SemanticObject> it=obj.listHerarquicalChilds();
                if(addChilds)
                {
                    Iterator<SemanticObject> it2=SWBComparator.sortSermanticObjects(lang, it);
                    while(it2.hasNext())
                    {
                        SemanticObject ch=it2.next();
                        boolean add=true;
                        if(ch.instanceOf(Resource.sclass))
                        {
                            Resource res=(Resource)ch.createGenericInstance();
                            if(res.getResourceSubType()!=null)add=false;
                            //if(add && restype.getResourceMode()==restype.MODE_SYSTEM)
                            //{
                            //    System.out.println("res.getResourceable():"+res.getResourceable());
                            //    if(res.getResourceable()!=null)add=false;
                            //}
                        }
                        if(add)addSemanticObject(childs, ch,false,user);
                    }
                }else
                {
                    if(it.hasNext())
                    {
                        hasChilds=true;
                    }
                }
            }
            if(hasChilds && !addChilds)
            {
                if (addDummy) {
                    childs.put(getDummyNode());
                } else {
                    jobj.put("hasChilds", "true");
                }
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }


    public void addSemanticObject(JSONArray arr, SemanticObject obj, boolean addChilds, User user) throws JSONException
    {
        addSemanticObject(arr, obj, addChilds, false,user);
    }

    public void addSemanticObject(JSONArray arr, SemanticObject obj, boolean addChilds, boolean addDummy, User user) throws JSONException
    {
        addSemanticObject(arr, obj, addChilds, addDummy, null, user);
    }

    public boolean checkInverse(SemanticClass cls, SemanticClass child, SemanticProperty inv)
    {
        boolean ret=false;
        if(inv!=null)
        {
            SemanticClass aux=null;
            SemanticRestriction res=inv.getValuesFromRestriction(child);
            if(res!=null)aux=res.getRestrictionValue();
            //System.out.println("res:"+res+" aux:"+aux);
            if(aux!=null)
            {
                if(res.isAllValuesFromRestriction())
                {
                    if(cls.equals(aux) || cls.isSubClass(aux))ret=true;
                }else if(res.isSomeValuesFromRestriction())
                {
                    if(cls.equals(aux))ret=true;
                }
            }else
            {
                ret=true;
            }
        }else
        {
            ret=true;
        }
        //System.out.println("cls:"+cls+" child:"+child+" inv:"+inv+" ret:"+ret);
        return ret;
    }

    public void addSemanticObject(JSONArray arr, SemanticObject obj, boolean addChilds, boolean addDummy, SemanticObject virparent, User user) throws JSONException
    {
        boolean fullaccess=SWBPortal.getAdminFilterMgr().haveAccessToSemanticObject(user, obj);
        if(!fullaccess && !SWBPortal.getAdminFilterMgr().haveChildAccessToSemanticObject(user, obj))return;
        if(obj.getBooleanProperty(Trashable.swb_deleted)==true)return;

        String lang=user.getLanguage();
        boolean hasChilds=false;
        SemanticClass cls=obj.getSemanticClass();
        SemanticModel model=obj.getModel();
        String type=cls.getClassId();
        
        boolean virtual=virparent!=null;
        //System.out.println("obj:"+obj+" virtual:"+virparent);

        //TODO:Comentaresto cuando liberemos rep. docs.
        if(cls.equals(org.semanticwb.repository.Workspace.sclass) || cls.getClassId().equals("swp:ProcessDataInstanceModel"))
        {
            return;
        }
        
        //TODO:validar treeController
        //System.out.println("type:"+type);
        if(cls.equals(ResourceType.sclass))
        {
            addResourceType(arr,obj,addChilds,addDummy,user);
            return;
        }
        //Active
        boolean active=false;
        SemanticProperty activeprop=cls.getProperty("active");
        if(activeprop!=null)
        {
            active=obj.getBooleanProperty(activeprop);
        }

        String uriext="";
        String icon=SWBContext.UTILS.getIconClass(obj);
        if(virtual)
        {
            uriext="|"+(nullnode++);
            icon="swbIconWebPageV";
        }
        //System.out.println(obj+" icon:"+icon);
        //if(cls.hasProperty(SWBClass.swb_valid.getName()))System.out.println(obj.getBooleanProperty(SWBClass.swb_valid));
        JSONObject jobj=getNode(obj.getURI()+uriext, obj.getDisplayName(lang), type, icon);
        arr.put(jobj);

        //dragSupport
        DisplayObject dp=DisplayObject.getDisplayObject(cls);
        if(dp!=null && !virtual)
        {
            jobj.put("dragSupport", dp.isDragSupport());
            jobj.put("dropMatchLevel", dp.getDropMatchLevel());
        }

        //System.out.println("obj:"+obj.getId());
        //Thread.currentThread().dumpStack();
        //drop acceptance
        JSONArray dropacc=new JSONArray();
        jobj.putOpt("dropacc", dropacc);

        //menus
        JSONArray menus=new JSONArray();
        jobj.putOpt("menus", menus);

        //TODO:separar treeController
        if(fullaccess && DisplayObject.canCreateChilds(cls) && !cls.equals(WebSite.sclass) && !cls.isSubClass(WebSite.sclass) && !virtual)
        {
            //menus creacion
            Iterator<SemanticProperty> pit=cls.listHerarquicalProperties();
            while(pit.hasNext())
            {
                SemanticProperty prop=pit.next();
                boolean subclasses=true;
                SemanticClass rcls=null;
                SemanticRestriction res=prop.getValuesFromRestriction(cls);
                if(res!=null)rcls=res.getRestrictionValue();
                if(rcls!=null)
                {
                    if(res.isSomeValuesFromRestriction())subclasses=false;
                }else
                {
                    rcls=prop.getRangeClass();
                }
                //System.out.println("obj:"+obj+" prop:"+prop+" cls:"+cls+" rcls:"+rcls);
                //Restricciones inversas
                SemanticProperty inv=prop.getInverse();

                if(SWBPortal.getAdminFilterMgr().haveClassAction(user, rcls, AdminFilter.ACTION_ADD))
                {
                    if(checkInverse(cls, rcls, inv))
                    {
                        DisplayObject dpc=DisplayObject.getDisplayObject(rcls);
                        if((dpc==null || !dpc.isDoNotInstanceable()) && DisplayObject.canCreate(rcls))
                        {
                            menus.put(getMenuItem(getLocaleString("add",lang)+" "+rcls.getDisplayName(lang), getLocaleString("icon_add",null),getAction("showDialog", SWBPlatform.getContextPath()+"/swbadmin/jsp/SemObjectEditor.jsp?scls="+rcls.getEncodedURI()+"&sref="+obj.getEncodedURI()+"&sprop="+prop.getEncodedURI(),getLocaleString("add",lang)+" "+rcls.getDisplayName(lang))));
                        }
                        dropacc.put(rcls.getClassId());
                    }
                }

                //add subclasess
                if(subclasses)
                {
                    Iterator<SemanticClass> it=rcls.listSubClasses();
                    while(it.hasNext())
                    {
                        SemanticClass scls=it.next();
                        if(model.hasModelClass(scls))
                        {
                            if(SWBPortal.getAdminFilterMgr().haveClassAction(user, scls, AdminFilter.ACTION_ADD))
                            {
                                if(checkInverse(cls, scls, inv))
                                {
                                    //System.out.println("addMenu");
                                    DisplayObject dpc=DisplayObject.getDisplayObject(scls);
                                    if((dpc==null || !dpc.isDoNotInstanceable()) && DisplayObject.canCreate(scls))
                                    {
                                        menus.put(getMenuItem(getLocaleString("add",lang)+" "+scls.getDisplayName(lang), getLocaleString("icon_add",null),getAction("showDialog", SWBPlatform.getContextPath()+"/swbadmin/jsp/SemObjectEditor.jsp?scls="+scls.getEncodedURI()+"&sref="+obj.getEncodedURI()+"&sprop="+prop.getEncodedURI(),getLocaleString("add",lang)+" "+scls.getDisplayName(lang))));
                                    }
                                    dropacc.put(scls.getClassId());
                                }
                            }
                        }
                    }
                }
            }
        }

        if(obj.instanceOf(WebPage.sclass))
        {
            WebPage page=(WebPage)obj.createGenericInstance();
            menus.put(getMenuItem(getLocaleString("preview",lang), getLocaleString("icon_preview",null), getAction("showPreviewURL",page.getUrl(),null)));
        }
        
        if(menus.length()>0)
            menus.put(getMenuSeparator());


        //Active
        if(fullaccess && SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_ACTIVE))
        {
            if(activeprop!=null && !virtual)
            {
                if(!active)
                {
                    menus.put(getMenuItem(getLocaleString("active",lang), getLocaleString("icon_active",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/active.jsp?suri="+obj.getEncodedURI()+"&act=active",null)));
                }else
                {
                    menus.put(getMenuItem(getLocaleString("unactive",lang), getLocaleString("icon_unactive",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/active.jsp?suri="+obj.getEncodedURI()+"&act=unactive",null)));
                }
            }
        }

        if(SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_EDIT))
        {
            menus.put(getMenuItem(getLocaleString("edit",lang), getLocaleString("icon_edit",null), getNewTabAction()));
        }
        //menus.put(getMenuItem(getLocaleString("clone",lang), getLocaleString("icon_clone",null), getAction("showStatusURLConfirm",SWBPlatform.getContextPath()+"/swbadmin/jsp/clone.jsp?suri="+obj.getEncodedURI(),getLocaleString("clone",lang)+" "+cls.getDisplayName(lang))));
        //menu remove

        if(fullaccess && DisplayObject.canDelete(cls) && SWBPortal.getAdminFilterMgr().haveClassAction(user, cls, AdminFilter.ACTION_DELETE))
        {
            if(!virtual)
            {
                if(!obj.instanceOf(Undeleteable.swb_Undeleteable) ||  (obj.instanceOf(Undeleteable.swb_Undeleteable) && obj.getBooleanProperty(Undeleteable.swb_undeleteable)==false))
                {
                    menus.put(getMenuItem(getLocaleString("delete",lang), getLocaleString("icon_delete",null), getAction("showStatusURLConfirm",SWBPlatform.getContextPath()+"/swbadmin/jsp/delete.jsp?suri="+obj.getEncodedURI(),getLocaleString("delete",lang)+" "+cls.getDisplayName(lang))));
                }
            }else
            {
                menus.put(getMenuItem(getLocaleString("deleteref",lang), getLocaleString("icon_delete",null), getAction("showStatusURLConfirm",SWBPlatform.getContextPath()+"/swbadmin/jsp/delete.jsp?suri="+obj.getEncodedURI()+"&virp="+virparent.getEncodedURI(),getLocaleString("deleteref",lang))));
            }
        }
        menus.put(getMenuSeparator());

        //menu favoritos
        if(!virtual)
        {
            boolean isfavo=user.hasFavorite(obj);
            if(!isfavo)
            {
                menus.put(getMenuItem(getLocaleString("addFavorites",lang), getLocaleString("icon_addFavorites",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=active",null)));
            }else
            {
                menus.put(getMenuItem(getLocaleString("deleteFavorites",lang), getLocaleString("icon_deleteFavorites",null), getAction("showStatusURL",SWBPlatform.getContextPath()+"/swbadmin/jsp/favorites.jsp?suri="+obj.getEncodedURI()+"&act=unactive",null)));
            }

            //menu recargar
            //TODO:validar recarga de virtual
            menus.put(getMenuReload(lang));
         }


        //eventos
        JSONArray events=new JSONArray();
        jobj.putOpt("events", events);
        events.put(getEvent("onDblClick", getAction("newTab", SWBPlatform.getContextPath()+"/swbadmin/jsp/objectTab.jsp", null)));
        events.put(getEvent("onClick", getAction("getHtml", SWBPlatform.getContextPath()+"/swbadmin/jsp/viewProps.jsp?id="+obj.getEncodedURI(), "vprop")));

        //hijos
        JSONArray childs=new JSONArray();

        if(!virtual)
        {
            hasChilds=hasHerarquicalNodes(obj,lang);
            if(addChilds || !hasChilds)
            {
                addHerarquicalNodes(childs, obj,user);

                boolean isWebPage=obj.instanceOf(WebPage.sclass);

                Iterator<SemanticObject> it=obj.listHerarquicalChilds();
                if(addChilds)
                {
                    Iterator<SemanticObject> it2=null;
                    if(isWebPage)
                    {
                        it2=SWBComparator.sortSermanticObjects(lang,it,obj.listObjectProperties(WebPage.swb_hasWebPageVirtualChild));
                    }else
                    {
                        it2=SWBComparator.sortSermanticObjects(lang,it);
                    }
                    while(it2.hasNext())
                    {
                        SemanticObject ch=it2.next();
                        SemanticObject vp=null;
                        if(isWebPage)
                        {
                            SemanticObject p=ch.getObjectProperty(WebPage.swb_webPageParent);
                            //System.out.println("ch:"+ch+" p:"+p+"="+obj);
                            if(obj!=p)vp=obj;
                        }
                        //System.out.println("vp:"+vp+" ch:"+ch+" class:"+ch.getSemanticClass().getClassId());
                        if(vp!=null && ch.getSemanticClass().getClassId().equals("swp:WrapperProcessWebPage"))
                        {
                            SemanticProperty prop=SWBPlatform.getSemanticMgr().getVocabulary().getSemanticPropertyById("swp:processWebPage");
                            Iterator<SemanticObject> it3=ch.getModel().listSubjects(prop, ch);
                            if(it3.hasNext())ch=it3.next();
                            //System.out.println("prop:"+prop+" ch:"+ch);

                        }
                        
                        //System.out.println("isVirtChild:"+isVirtChild);
                        addSemanticObject(childs, ch, false, false, vp,user);
                    }
                }else
                {
                    if(it.hasNext())
                    {
                        hasChilds=true;
                    }else if(isWebPage)
                    {
                        hasChilds=obj.listObjectProperties(WebPage.swb_hasWebPageVirtualChild).hasNext();
                    }

                }
            }
            if(hasChilds && !addChilds)
            {
                if (addDummy) {
                    childs.put(getDummyNode());
                } else {
                    jobj.put("hasChilds", "true");
                }
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }

/****************************************************************************/

    public void addHNClasses(JSONArray arr, HerarquicalNode node, SemanticObject obj, boolean addChilds, User user) throws JSONException
    {
        SemanticModel model=obj.getModel();
        String pf=node.getPropertyFilter();
        JSONObject jobj=getNode("HN|"+obj.getURI()+"|"+node.getURI(), node.getDisplayTitle(user.getLanguage()), "HerarquicalNode", node.getIconClass());
        arr.put(jobj);

        JSONArray childs=new JSONArray();

        SemanticOntology ont=SWBPlatform.getSemanticMgr().getSchema();
        ArrayList<OntClass> carr=new ArrayList();
        //Add default Classes
        //carr.add(ont.getRDFOntModel().getOntClass(SemanticVocabulary.RDF_PROPERTY));
        //carr.add(ont.getRDFOntModel().getOntClass(SemanticVocabulary.OWL_CLASS));
        Iterator<OntClass> it=null;
        if(addChilds)
        {
            //it=ont.getRDFOntModel().listHierarchyRootClasses();
            it=ont.getRDFOntModel().listClasses();
            while (it.hasNext())
            {
                OntClass cls = it.next();
                if(!cls.isAnon())
                {
                    System.out.println("xx:"+cls);
                    Iterator itc=cls.listSuperClasses();
                    if(!itc.hasNext())
                    {
                        //Object elem = itc.next();
                        carr.add(cls);
                        //System.out.println("-->xx:"+elem);
                    }

                }
            }
        }
        it=carr.iterator();

        //System.out.println("obj:"+obj.getId()+" cls:"+cls);
        //drop acceptance
        JSONArray dropacc=new JSONArray();
        jobj.putOpt("dropacc", dropacc);

        //Menus
        JSONArray menus=new JSONArray();
        jobj.putOpt("menus", menus);
        String url=SWBPlatform.getContextPath();

        //Agregar clases
        {
            url+="/swbadmin/jsp/addClass.jsp";
            url+="?sref="+obj.getEncodedURI();
            if(pf!=null)url+="&"+pf;
            String title=getLocaleString("add",user.getLanguage())+" "+getLocaleString("class",user.getLanguage());
            menus.put(getMenuItem(title, getLocaleString("icon_add",null),getAction("showDialog", url,title)));
            dropacc.put("rdfs:Class");
            menus.put(getMenuSeparator());
        }
        menus.put(getMenuReload(user.getLanguage()));

        if(addChilds)
        {
            Iterator<HerarquicalNode> sit=SWBComparator.sortSortableObject(node.listHerarquicalNodes());
            while(sit.hasNext())
            {
                HerarquicalNode cnode=sit.next();
                //System.out.println("cnode:"+cnode);
                addHerarquicalNode(childs,cnode,obj,false,user);
            }

            while(it.hasNext())
            {
                OntClass cls=it.next();
                addClass(childs, cls,false,model,user);
            }
        }else
        {
            //Tiene HN
            Iterator<HerarquicalNode> sit=node.listHerarquicalNodes();

            if(it.hasNext() || sit.hasNext())
            {
                jobj.put("hasChilds", "true");
                JSONArray events=new JSONArray();
                jobj.putOpt("events", events);
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }

    public void addHNProperties(JSONArray arr, HerarquicalNode node, SemanticObject obj, boolean addChilds, User user) throws JSONException
    {
        SemanticModel model=obj.getModel();
        String pf=node.getPropertyFilter();
        JSONObject jobj=getNode("HN|"+obj.getURI()+"|"+node.getURI(), node.getDisplayTitle(user.getLanguage()), "HerarquicalNode", node.getIconClass());
        arr.put(jobj);

        JSONArray childs=new JSONArray();

        SemanticOntology ont=SWBPlatform.getSemanticMgr().getSchema();
        ArrayList<OntProperty> carr=new ArrayList();
        Iterator<OntProperty> it=null;
        if(addChilds)
        {
            it=ont.getRDFOntModel().listAllOntProperties();
            while (it.hasNext())
            {
                OntProperty prop = it.next();
                if(!prop.isAnon())
                {
                    //Filter
                    if(prop.getNameSpace().indexOf("proy")>-1)
                    {
                        carr.add(prop);
                        System.out.println("prop:"+prop);
                    }
                }
            }
        }
        it=carr.iterator();

        //System.out.println("obj:"+obj.getId()+" cls:"+cls);
        //drop acceptance
        JSONArray dropacc=new JSONArray();
        jobj.putOpt("dropacc", dropacc);

        //Menus
        JSONArray menus=new JSONArray();
        jobj.putOpt("menus", menus);
        String url=SWBPlatform.getContextPath();

        //Agregar Propiedades
        {
            url+="/swbadmin/jsp/addProperty.jsp";
            url+="?sref="+obj.getEncodedURI();
            if(pf!=null)url+="&"+pf;
            String title=getLocaleString("add",user.getLanguage())+" "+getLocaleString("property",user.getLanguage());
            menus.put(getMenuItem(title, getLocaleString("icon_add",null),getAction("showDialog", url,title)));
            dropacc.put("rdfs:Property");
            menus.put(getMenuSeparator());
        }
        menus.put(getMenuReload(user.getLanguage()));

        if(addChilds)
        {
            Iterator<HerarquicalNode> sit=SWBComparator.sortSortableObject(node.listHerarquicalNodes());
            while(sit.hasNext())
            {
                HerarquicalNode cnode=sit.next();
                //System.out.println("cnode:"+cnode);
                addHerarquicalNode(childs,cnode,obj,false,user);
            }

            while(it.hasNext())
            {
                OntProperty prop=it.next();
                addProperty(childs, prop,false,model,user);
            }
        }else
        {
            //Tiene HN
            Iterator<HerarquicalNode> sit=node.listHerarquicalNodes();

            //if(it.hasNext() || sit.hasNext())
            {
                jobj.put("hasChilds", "true");
                JSONArray events=new JSONArray();
                jobj.putOpt("events", events);
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }

    public void addClass(JSONArray arr, OntClass cls, boolean addChilds, SemanticModel model, User user) throws JSONException
    {
        System.out.println("cls:"+cls);
        if(cls==null)return;
        boolean base=false; //TODO //SWBPlatform.JENA_UTIL.isInBaseModel(cls, ont.getRDFOntModel());

        String icon="swbIconClass";
        //if(!base)icon+="U";
        JSONObject jobj=getNode(cls.getURI()+"|"+(nullnode++), SWBPlatform.JENA_UTIL.getId(cls), "Class", icon);
        arr.put(jobj);

        //hijos
        JSONArray childs=new JSONArray();

        //eventos
        JSONArray events=new JSONArray();
        jobj.putOpt("events", events);
        events.put(getEvent("onDblClick", getAction("newTab", SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp", null)));
        //events.put(getEvent("onClick", getAction("getHtml", SWBPlatform.getContextPath()+"/swbadmin/jsp/viewProps.jsp?id="+obj.getEncodedURI(), "vprop")));

        Iterator<OntClass> it=cls.listSubClasses(true);

        if(addChilds)
        {
            while(it.hasNext())
            {
                OntClass ccls=it.next();
                addClass(childs,ccls,false,model,user);
            }
        }else
        {
            if(it.hasNext())
            {
                jobj.put("hasChilds", "true");
                events=new JSONArray();
                jobj.putOpt("events", events);
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }

    public void addProperty(JSONArray arr, OntProperty prop, boolean addChilds, SemanticModel model, User user) throws JSONException
    {
        if(prop==null)return;
        boolean base=false; //TODO //SWBPlatform.JENA_UTIL.isInBaseModel(cls, ont.getRDFOntModel());

        String icon="swbIconProperty";
        //if(!base)icon+="U";
        JSONObject jobj=getNode(prop.getURI()+"|"+(nullnode++), SWBPlatform.JENA_UTIL.getId(prop), "Class", icon);
        arr.put(jobj);

        //hijos
        JSONArray childs=new JSONArray();

        //eventos
        JSONArray events=new JSONArray();
        jobj.putOpt("events", events);
        events.put(getEvent("onDblClick", getAction("newTab", SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp", null)));
        //events.put(getEvent("onClick", getAction("getHtml", SWBPlatform.getContextPath()+"/swbadmin/jsp/viewProps.jsp?id="+obj.getEncodedURI(), "vprop")));

        Iterator it=prop.listSubProperties();
        if(addChilds)
        {
            while(it.hasNext())
            {
                OntProperty ch=(OntProperty)it.next();
                addProperty(childs,ch,false,model,user);
            }
        }else
        {
            if(it.hasNext())
            {
                jobj.put("hasChilds", "true");
                events=new JSONArray();
                jobj.putOpt("events", events);
                events.put(getEvent("onOpen", getReloadAction()));
            }
        }
        if(childs.length()>0)jobj.putOpt("children", childs);
    }
/*
    public void addClasses(JSONArray arr, SemanticOntology ont)  throws JSONException
    {
        //System.out.println("addClasses");
        Iterator<OntClass> it=ont.getRDFOntModel().listHierarchyRootClasses();
        while(it.hasNext())
        {
            OntClass cls=it.next();
            if(!cls.isAnon())
            {
                //System.out.println("cls:"+cls+" "+cls.isAnon()+" "+cls.getLocalName());
                addClass(arr, cls, ont);
            }
        }
        addClass(arr, ont.getRDFOntModel().getOntClass(SemanticVocabulary.RDF_PROPERTY), ont);
        addClass(arr, ont.getRDFOntModel().getOntClass(SemanticVocabulary.OWL_CLASS), ont);
    }

    public void addClass(JSONArray arr, OntClass cls, SemanticOntology ont) throws JSONException
    {
        if(cls==null)return;
        boolean base=SWBPlatform.JENA_UTIL.isInBaseModel(cls, ont.getRDFOntModel());
        String icon="swbIconClass";
        if(!base)icon+="U";
        JSONObject jobj=getNode(cls.getURI()+"|"+(nullnode++), SWBPlatform.JENA_UTIL.getId(cls), "Class", icon);
        arr.put(jobj);

        //hijos
        JSONArray childs=new JSONArray();
        jobj.putOpt("children", childs);

        //eventos
        JSONArray events=new JSONArray();
        jobj.putOpt("events", events);
        events.put(getEvent("onDblClick", getAction("newTab", SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp", null)));
        //events.put(getEvent("onClick", getAction("getHtml", SWBPlatform.getContextPath()+"/swbadmin/jsp/viewProps.jsp?id="+obj.getEncodedURI(), "vprop")));

        Iterator<OntClass> it=cls.listSubClasses(true);
        while(it.hasNext())
        {
            OntClass ccls=it.next();
            addClass(childs, ccls,ont);
        }
    }

    public void addProperties(JSONArray arr, SemanticOntology ont)  throws JSONException
    {
        Iterator<OntProperty> it=ont.getRDFOntModel().listAllOntProperties();
        while(it.hasNext())
        {
            OntProperty prop=it.next();
            addProperty(arr, prop, ont);
        }
    }

    public void addProperty(JSONArray arr, OntProperty prop, SemanticOntology ont) throws JSONException
    {
        if(prop==null)return;
        boolean base=SWBPlatform.JENA_UTIL.isInBaseModel(prop, ont.getRDFOntModel());
                //isInBaseModel(prop);
        String icon="swbIconClass";
        if(!base)icon+="U";
        JSONObject jobj=getNode(prop.getURI()+"|"+(nullnode++), SWBPlatform.JENA_UTIL.getId(prop), "Property", icon);
        arr.put(jobj);

        //hijos
        JSONArray childs=new JSONArray();
        jobj.putOpt("children", childs);

        //eventos
        JSONArray events=new JSONArray();
        jobj.putOpt("events", events);
        events.put(getEvent("onDblClick", getAction("newTab", SWBPlatform.getContextPath()+"/swbadmin/jsp/resourceTab.jsp", null)));
        //events.put(getEvent("onClick", getAction("getHtml", SWBPlatform.getContextPath()+"/swbadmin/jsp/viewProps.jsp?id="+obj.getEncodedURI(), "vprop")));

        Iterator it=prop.listSubProperties(true);
        while(it.hasNext())
        {
            OntProperty cprop=(OntProperty)it.next();
            addProperty(childs, cprop,ont);
        }
    }
 */
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
    //System.out.println("Inicio");
    String lang="es";
    if(user!=null)lang=user.getLanguage();

    String id=request.getParameter("id");
    if(id==null)id="mtree";

    SemanticOntology sont=null;
    //SemanticOntology sont=(SemanticOntology)session.getAttribute("ontology");
    if(id.equals("mclass")||id.equals("mprop"))
    {
        sont=getOntology(session);
    }

    //Iterator mit=sont.getRDFOntModel().listSubModels();
    //while(mit.hasNext())
    //{
    //    OntModel model=(OntModel)mit.next();
    //    //System.out.println(model.getNsPrefixMap());
    //}
    //System.out.println("fin");

    //System.out.println(new Date()+" Tree1");
    SemanticOntology ont=SWBPlatform.getSemanticMgr().getOntology();

    response.setHeader("Cache-Control", "no-cache"); 
    response.setHeader("Pragma", "no-cache"); 
    
    String suri=request.getParameter("suri");
    String type=request.getParameter("type");
    //System.out.println("suri:"+suri);
    if(suri==null)
    {
        //System.out.println("gen1");
        JSONObject obj=new JSONObject();
        obj.put("identifier", "id");
        obj.put("label","title");
        JSONArray items=new JSONArray();
        obj.putOpt("items", items);
        //System.out.println("gen2");
        if(id.equals("mtree"))addWebSites(items,user);
        if(id.equals("muser"))addUserReps(items,user);
        if(id.equals("mont"))addOntologies(items,user);
        if(id.equals("mfavo"))addFavorites(items,user);
        if(id.equals("mtra")) addWebSitesTrash(items,user);
        if(id.equals("mdoc")) addDocRepositories(items,user);
        //if(id.equals("mclass")) addClasses(items,sont);
        //if(id.equals("mprop")) addProperties(items,sont);
        //System.out.println("gen3");
        out.print(obj.toString());
        //System.out.print(id);
    }else
    {
        boolean addChilds=true;
        String childs=request.getParameter("childs");
        if(childs!=null && childs.equals("false"))addChilds=false;

        JSONArray items=new JSONArray();
        if(suri.startsWith("HN|"))
        {
            StringTokenizer st=new StringTokenizer(suri,"|");
            String aux=st.nextToken();
            String ouri=st.nextToken();
            String nuri=st.nextToken();
            //System.out.println("aux:"+aux+" ouri:"+ouri+" nuri:"+nuri);
            if(ouri!=null && nuri!=null)
            {
                SemanticObject obj=ont.getSemanticObject(ouri);
                SemanticObject nobj=ont.getSemanticObject(nuri);
                //System.out.println("obj:"+obj+" node:"+nobj);
                HerarquicalNode node=new HerarquicalNode(nobj);
                addHerarquicalNode(items,node,obj,addChilds,user);
            }
        }else
        {
            if(type!=null && type.equals("Class"))
            {
                //Eliminar contador
                int ind=suri.indexOf('|');
                if(ind>0)
                {
                    suri=suri.substring(0,ind);
                }
                SemanticOntology so=SWBPlatform.getSemanticMgr().getSchema();
                OntClass cls=so.getRDFOntModel().getOntClass(suri);
                System.out.println(cls+" "+suri);
                SemanticModel model=null; //TODO: obtener modelo
                addClass(items, cls, true, model, user);
            }else
            {
                SemanticObject sobj=ont.getSemanticObject(suri);
                if(sobj!=null)
                {
                    addSemanticObject(items, sobj,addChilds,user);
                    Iterator<SemanticObject> it=sobj.listHerarquicalParents();
                    if(it.hasNext())
                    {
                        JSONObject obj=items.getJSONObject(0);
                        obj.put("parent", it.next().getURI());
                    }
                }
            }
        }
        out.print(items.toString());
    }    

    /*
{ identifier: 'name',
  label: 'name',
  items: [
     { name:'Africa', type:'continent', children:[{ name:'Kenya', type:'country'}, {_reference:'Sudan'}] },
     { name:'Nairobi', type:'city' },
     { name:'Mombasa', type:'city' },
     { name:'Sudan', type:'country', children:{_reference:'Khartoum'} },
     { name:'Khartoum', type:'city' },
     { name:'Argentina', type:'country'}
]}
    */
    //System.out.println(new Date()+" Tree2");
%>
