/**
 * SemanticWebBuilder es una plataforma para el desarrollo de portales y aplicaciones de integración,
 * colaboración y conocimiento, que gracias al uso de tecnología semántica puede generar contextos de
 * información alrededor de algún tema de interés o bien integrar información y aplicaciones de diferentes
 * fuentes, donde a la información se le asigna un significado, de forma que pueda ser interpretada y
 * procesada por personas y/o sistemas, es una creación original del Fondo de Información y Documentación
 * para la Industria INFOTEC, cuyo registro se encuentra actualmente en trámite.
 *
 * INFOTEC pone a su disposición la herramienta SemanticWebBuilder a través de su licenciamiento abierto al público (‘open source’),
 * en virtud del cual, usted podrá usarlo en las mismas condiciones con que INFOTEC lo ha diseñado y puesto a su disposición;
 * aprender de él; distribuirlo a terceros; acceder a su código fuente y modificarlo, y combinarlo o enlazarlo con otro software,
 * todo ello de conformidad con los términos y condiciones de la LICENCIA ABIERTA AL PÚBLICO que otorga INFOTEC para la utilización
 * del SemanticWebBuilder 4.0.
 *
 * INFOTEC no otorga garantía sobre SemanticWebBuilder, de ninguna especie y naturaleza, ni implícita ni explícita,
 * siendo usted completamente responsable de la utilización que le dé y asumiendo la totalidad de los riesgos que puedan derivar
 * de la misma.
 *
 * Si usted tiene cualquier duda o comentario sobre SemanticWebBuilder, INFOTEC pone a su disposición la siguiente
 * dirección electrónica:
 *  http://www.semanticwebbuilder.org
 **/

import org.semanticwb.portal.api.*
import org.semanticwb.model.*
import org.semanticwb.portal.community.*
import org.semanticwb.*
import org.semanticwb.platform.*
import java.util.*


//def paramRequest=request.getAttributeNames()
//paramRequest.each{
//    println it
//}
//
//println "<pre>Ready"
//long time1 = System.currentTimeMillis()
WebPage topic = (WebPage)request.getAttribute("topic")
WebPage lugar = topic.getWebSite().getWebPage("Sitios_de_Interes")
TreeSet setLugar= new TreeSet(new SWBComparator("es"))
WebPage servicio = topic.getWebSite().getWebPage("Servicios")
TreeSet setServicio= new TreeSet(new SWBComparator("es"))
WebPage organizacion = topic.getWebSite().getWebPage("Organizaciones")
TreeSet setOrg= new TreeSet(new SWBComparator("es"))


def lista = topic.listChilds()
lista.each{
    WebPage act = (WebPage) it
    //System.out.println ""+(!act.getClass().equals(MicroSite.class)) +"--"+it
    if ((!act.getClass().equals(MicroSite.class))&&act.isValid()) {
       // println ""+act+" - "+act.isActive()+"-"+act.isDeleted()+"-"+act.isHidden()+"-"+act.isOnSchedule()
        if(findif(act,lugar)) setLugar.add(act)
        if(findif(act,servicio)) setServicio.add(act)
        if(findif(act,organizacion)) setOrg.add(act)
    }
}

lista = topic.listWebPageVirtualChilds()
lista.each{
    WebPage act = (WebPage) it
    //System.out.println ""+(!act.getClass().equals(MicroSite.class)) +"--"+it
    if ((!act.getClass().equals(MicroSite.class))&&act.isValid()) {
       // println ""+act+" - "+act.isActive()+"-"+act.isDeleted()+"-"+act.isHidden()+"-"+act.isOnSchedule()
        if(findif(act,lugar)) setLugar.add(act)
        if(findif(act,servicio)) setServicio.add(act)
        if(findif(act,organizacion)) setOrg.add(act)
    }
}

//println topic
//println"</pre>"
def flag = false
if (setLugar.size()>0){
    println """      	<h2><strong>Lugares</strong> (${setLugar.size()} elementos relevantes publicados)</h2>
                     <ul class="itemsCategoriaTema">"""
    lista = setLugar.iterator()
    lista.each{
        WebPage curr = (WebPage)it

        println "                  <li><a href=\"${curr.getRealUrl()}\">${curr.getDisplayName("es")}</a></li>"
    }
    println "                </ul>"
    flag = true
}

if (setServicio.size()>0){
    if (flag){
        println "                <div class=\"clear\">&nbsp;<!--Este estilo es necesario para cortar la secuencia de dos columnas--></div>"
        flag = false
    }
    println """                <h2><strong>Servicios</strong> (${setServicio.size()} elementos importantes publicados)</h2>
                      <ul class="itemsCategoriaTema">"""
    lista = setServicio.iterator()
    lista.each{
        WebPage curr = (WebPage)it

        println "                  <li><a href=\"${curr.getRealUrl()}\">${curr.getDisplayName("es")}</a></li>"
    }
    println "                </ul>"
        flag = true
}

if (setOrg.size()){
    if (flag) println "                <div class=\"clear\">&nbsp;<!--Este estilo es necesario para cortar la secuencia de dos columnas--></div>"
    println """                  <h2><strong>Organizaciones</strong> (${setOrg.size()} elementos importantes publicados)</h2>
                      <ul class="itemsCategoriaTema">"""
    lista = setOrg.iterator()
    lista.each{
        WebPage curr = (WebPage)it

        println "                  <li><a href=\"${curr.getRealUrl()}\">${curr.getDisplayName("es")}</a></li>"
    }

    println "                  </ul>"
}

//long time = System.currentTimeMillis() - time1
//System.out.println "listo --->$time"



static boolean findif(WebPage curr, WebPage lookup) {
    //println "buscando: $curr contra $lookup"
    def parents = curr.listVirtualParents()
    boolean flag = false
    parents.each{
        if (!flag) {
            WebPage parent = (WebPage) it
            //println parent
            if (parent.equals(lookup)) {
            flag = true
            }
            else {
               flag = findif(parent, lookup)
            }
        }
    }
    if (!flag) {
        WebPage parent = curr.getParent()
        if (null!=parent){
            //println parent
            if (parent.equals(lookup)) {
            flag = true
            }
            else {
               flag = findif(parent, lookup)
            }
        }
    }
    return flag
}