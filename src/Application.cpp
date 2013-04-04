/*
* Copyright (C) 2011 Ramil Mintaev
*
* See the LICENSE file for terms of use.
*/

#include "Application.hpp"
#include "Example.hpp"

using namespace Wt;

namespace MV {

Application::Application(const Wt::WEnvironment& env):
    Wt::WApplication(env) {
        WContainerWidget* cw = new WContainerWidget(root());
        new Example(cw);
}

Application* Application::instance() {
    return static_cast<Application*>(Wt::WApplication::instance());
}

}

