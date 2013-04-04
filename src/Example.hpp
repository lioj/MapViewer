/*
* Copyright (C) 2011 Ramil Mintaev
*
* See the LICENSE file for terms of use.
*/

#ifndef MV_EXAMPLE_HPP_
#define MV_EXAMPLE_HPP_

#include <Wt/WContainerWidget>
#include <Wt/WLineEdit>
#include <Wt/WText>

#include "MapViewer.hpp"

using namespace Wt;

namespace MV {

class Example  : public Wt::WContainerWidget {
public:
    Example(WContainerWidget* p=0);
private:
    void set_zoom_to();
    void set_pan_to();
    void get_pos(const MapViewer::Coordinate& pos);
    void left_shift();
    void right_shift();
    void top_shift();
    void bottom_shift();
    void get_search(MapViewer::GeoNode node);
    void search_pr(WLineEdit* edit);
    void search_presenting(WContainerWidget* cw,
            const MapViewer::GeoNodes& nodes);
    void get_time_zone(const MapViewer::TZ& tz);

    MapViewer* mv_;
    WLineEdit* edit_of_zoom_to_;
    WLineEdit* edit_of_pan_to_lng_;
    WLineEdit* edit_of_pan_to_lat_;
    WText* click_pos_;
    WText* click_search_;
    WText* time_zone_;
};

}

#endif

