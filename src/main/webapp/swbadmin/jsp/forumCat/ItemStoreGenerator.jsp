<%-- 
    Document   : ItemStoreGenerator
    Created on : 8/06/2010, 10:39:18 AM
    Author     : jose.jimenez
    Construye y muestra la estructura de un árbol en un objeto JSON, a partir de la página Web
    que tenga por uri, el valor recibido en el párámetro "uri".
--%>
<%@page import="org.json.*, org.semanticwb.model.*, org.semanticwb.platform.*, java.util.*" %>
<%@page contentType="text/html" %><%@page pageEncoding="UTF-8" %>
<%!

    private JSONObject spawnJSONObject(String id, boolean hasChildren, String name,
            String tpurl, String type, boolean loaded) {

        JSONObject jo = new JSONObject();
        try {
            jo.put("id", id);
            jo.put("carpeta", hasChildren);
            jo.put("loaded", loaded);
            jo.put("name", name);
            jo.put("tpurl", tpurl);
            jo.put("type", type);
            if (hasChildren) {
                JSONArray items = new JSONArray();
                jo.put("children", items);
            }
        } catch (JSONException jsone) {
            jsone.printStackTrace();
        }
        return jo;
    }

    private JSONObject spawnJSONObject(WebPage wp, int level) {

        JSONObject jo = new JSONObject();
        try {
            boolean hasChildren = (wp.listChilds() != null && wp.listChilds().hasNext()) ? true : false;
            String type = level > 0 ? wp.getParent().getId() : wp.getId();
            jo.put("id", wp.getId());
            jo.put("carpeta", hasChildren);
            jo.put("loaded", true);
            jo.put("name", wp.getTitle());
            jo.put("tpurl", wp.getURI());
            jo.put("type", type);
            if (hasChildren) {
                JSONArray items = getChildren(wp, level + 1);
                jo.put("children", items);
            }
            /*
            for (int i = 0; i < level; i++) {
                System.out.print("    ");
            }
            System.out.print(level + " : ");
            System.out.println(wp.getTitle());
  */
        } catch (JSONException jsone) {
            jsone.printStackTrace();
        }
        return jo;
    }

    private JSONArray getChildren(WebPage wp, int level) {

        JSONArray array = new JSONArray();
            Iterator<WebPage> ittp = wp.listChilds();
            if (ittp.hasNext()) {

                while (ittp.hasNext()) {
                    WebPage tp1 = ittp.next();
                    if (null != tp1) {
                        boolean hasChildren = tp1.listChilds().hasNext() ? true : false;
                        JSONObject jo = spawnJSONObject(tp1, level);
//                        JSONObject jo = spawnJSONObject(tp1.getId(), hasChildren, tp1.getTitle(),
//                                tp1.getEncodedURI(), tp1.getParent().getId(), !hasChildren);
                        array.put(jo);
                    }
                }
            }
        return array;
    }
%><%
    StringBuffer ret = new StringBuffer(100);
    String uri = request.getParameter("uri");
    WebPage tptmp = null;
    if (uri != null) {
        try {
            SemanticObject semObjt = SemanticObject.createSemanticObject(request.getParameter("uri"));
            tptmp = (WebPage) semObjt.createGenericInstance();
            //Se forma la definicion de la estructura general del store
            JSONObject def = new JSONObject();
            def.put("identifier", "id");
            def.put("label", "name");
            //Se genera el elemento raiz del arbol
            JSONObject root = spawnJSONObject(tptmp, 0);
            //JSONArray rootItems = getChildren(tptmp);
            //Se anexan los elementos del raiz
            //root.put("children", rootItems);
            JSONArray items = new JSONArray();
            //Se anexa el elemento raiz a la estructuta general
            items.put(root);
            def.put("items", items);
            out.print(def.toString(4));
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        out.print("Hace falta el valor del parametro: uri");
    }
%>