/*
* Copyright (C) 2011 Ramil Mintaev
*
* See the LICENSE file for terms of use.
*/

#ifndef MV_APPLICATION_HPP_
#define MV_APPLICATION_HPP_

#include <Wt/WApplication>

namespace MV {

/** Macro for Application::instance(), same as wApp */
//#define wApp OMV::Application::instance()

/** Descendant of WApplication.
Active Application instance can be accessed using instance() static method
or mApp macro.

*/
class Application  : public Wt::WApplication {
public:
    /** Contructor.
    \param enc env passing to Wt::WApplication constructor
    \param server running server instance
    */
    Application(const Wt::WEnvironment& env);

    /** Get active Application.
    Same as WApplication::instance().
    There is macro for this method: wApp.
    */
    static Application* instance();



};

}

#endif

