
#include "Application.hpp"

Wt::WApplication* createMapViewerLiteApp(const Wt::WEnvironment& env) {
    return new MV::Application(env);
}

int main(int argc, char** argv) {
        return Wt::WRun(argc, argv, &createMapViewerLiteApp);
}

