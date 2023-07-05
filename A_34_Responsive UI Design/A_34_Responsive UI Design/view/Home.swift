//
//  Home.swift
//  A_34_Responsive UI Design
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI
import Charts

struct Home: View {
    
    @State var currentTab: String = "Home"
    @Namespace var animation
    
    @State var showSideBar: Bool = false
    
    var props: Properties
    var body: some View {
        HStack(spacing: 0) {
            
            if props.isiPad {
                ViewThatFits {
                    SideBar()
                    ScrollView(.vertical, showsIndicators: false) {
                        SideBar()
                    }
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView()
                    InfoCards()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            GraphView()
                            PieChartView()
                        }
                        .padding(.horizontal, 15)
                    }
                    .padding(.horizontal, -15)
                }
                .padding(15)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            Color.black
                .opacity(0.04)
                .ignoresSafeArea()
        }
        .overlay(alignment: .leading) {
            // MARK: Side Bar For Non iPad Devices
            ViewThatFits {
                SideBar()
                ScrollView(.vertical, showsIndicators: false) {
                    SideBar()
                }
            }
            .offset(x: showSideBar ? 0 : -100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                Color.black
                    .opacity(showSideBar ? 0.25: 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSideBar.toggle()
                        }
                    }
            }
        }
    }
}


// MARK: Side bar
extension Home {
    @ViewBuilder
    func SideBar() -> some View {
        // MARK: Tabs
        let tabs:[String] = [
            "Home",
            "Category",
            "Document",
            "Chart",
            "Bag",
            "Graph",
            "Notification",
            "Setting"
        ]
        
        VStack(spacing: 10) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 55, height: 55)
                .padding(.bottom, 10)
            ForEach(tabs, id: \.self) { tab in
                VStack(spacing: 8) {
                    Image(tab)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    
                    Text(tab)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(currentTab == tab ?  .orange : .gray)
                .padding(.vertical, 13)
                .frame(width: 65)
                .background {
                    if currentTab == tab {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.orange.opacity(0.1))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        currentTab = tab
                    }
                }
            }
            
            
            // MARK: Profile icon
            Button {
                
            } label: {
                VStack {
                    Image("avator_1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text("Profile")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }

            
        }
        .padding(.vertical)
        .padding(.top, 20)
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: 100)
        .background {
            Color.white
                .ignoresSafeArea()
        }
    }
}

// MARK: Header View
extension Home {
    @ViewBuilder
    func HeaderView() -> some View {
        // MARK: Dynamic Layout (ios 16+)
        let layout = props.isiPad && !props.isMaxSplit ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 22))
        
        layout {
            VStack(alignment: .leading,spacing: 8) {
                Text("Seattle, New York")
                    .font(.title2)
                    .fontWeight(.heavy)
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: Search Bar with menu button
            HStack(spacing: 10) {
                if !(props.isiPad && !props.isMaxSplit) {
                    Button {
                        withAnimation {
                            showSideBar.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    TextField("Search", text: .constant(""))
                    
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)

                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(.white)
            }
            
            
        }
    }
}


extension Home {
    @ViewBuilder
    func InfoCards() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 18) {
                ForEach(sample_infos, id: \.self) { info in
                    VStack(alignment: .leading, spacing: 18) {
                        HStack(spacing: 15) {
                            Text(info.title)
                                .font(.title3.bold())
                            Spacer()
                            HStack(spacing: 8) {
                                Image(systemName: info.loss ? "arrow.down": "arrow.up")
                                Text("\(info.percentage)%")
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(info.loss ? .red : .gray)
                        }
                        
                        HStack(spacing: 18) {
                            Image(systemName: info.icon)
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 45, height: 45)
                                .background {
                                    Circle()
                                        .fill(info.iconColor)
                                }
                            Text(info.amount)
                                .font(.title.bold())
                                
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                    }
                }
            }
            .padding(15)
        }
        .padding(.horizontal, -15)
    }
}


// MARK: Graph View
extension Home {
    @ViewBuilder
    func GraphView() -> some View {
        VStack(alignment: .leading,spacing: 15) {
            Text("Daily Sales")
                .font(.title3.bold())
            Chart {
                ForEach(sample_sales) { sale in
                    // MARK: Area Mark for gradient bg
                    AreaMark(x: .value("Time", sale.time), y: .value("Sale", sale.sales))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.linearGradient(colors: [
                            .orange.opacity(0.6),
                            .orange.opacity(0.5),
                            .orange.opacity(0.3),
                            .orange.opacity(0.1),
                            .clear
                        ], startPoint: .top, endPoint: .bottom))
                    
                    // MARK: Line Mark
                    LineMark(x: .value("Time", sale.time), y: .value("Sale", sale.sales))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.orange)
                    
                    PointMark(x: .value("Time", sale.time), y: .value("Sale", sale.sales))
                        .foregroundStyle(.orange)
                }
            }
            .frame(height: 180)
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
        }
        .frame(minWidth: props.size.width - 30)
    }
}


extension Home {
    @ViewBuilder
    func PieChartView() -> some View {
        VStack(alignment: .leading,spacing: 15) {
            Text("Total Income")
                .font(.title2.bold())
            
            ZStack {
                Circle()
                    .trim(from: 0.5, to: 1)
                    .stroke(.green,style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                Circle()
                    .trim(from: 0.2, to: 0.5)
                    .stroke(.red,style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(.yellow,style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                
                Text("$200K")
                    .font(.title)
                    .fontWeight(.heavy)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            HStack(spacing: 15) {
                Label {
                    Text("Food")
                        .font(.caption)
                        .foregroundColor(.black)
                } icon: {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
                
                Label {
                    Text("Drink")
                        .font(.caption)
                        .foregroundColor(.black)
                } icon: {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundColor(.red)
                }
                
                Label {
                    Text("Others")
                        .font(.caption)
                        .foregroundColor(.black)
                } icon: {
                    Image(systemName: "circle.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }

            }
        }
        .padding(15)
        .frame(width: 250, height: 250)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
