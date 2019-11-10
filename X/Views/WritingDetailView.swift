//
//  WritingDetailView.swift
//  X
//
//  Created by xhd2015 on 2019/11/6.
//  Copyright © 2019 snu2017. All rights reserved.
//

import SwiftUI

struct WritingDetailView: View {

    typealias EditorAction = () throws -> Void

    @State var writing: Writing {
        didSet {
            self.updateLinkList()
        }
    }
    @State var remarks: [Remark]? = nil
    @State var showAlert: Bool = false
    @State var alertContent: String = ""
    @State var alertTitle: String = ""

    @State var tagMaps: [TagMap]? = nil

    @State var showEditor: Bool = false
    @State var editorHint: String = ""
    @State var editContent: String = ""
    // "", tag, link, remark
    @State var editType: String = ""
    @State var editConfirmAction: EditorAction = {
    }

    @State var enteredLinkSelection: Bool = false

    // for return
    @State var linkIds: [Int64] {
        didSet {
            let vLinkIds = NSMutableOrderedSet()
            for id in self.linkIds {
                vLinkIds.add(id)
            }
            self.linkIdSet = vLinkIds
        }
    }
    @State var linkIdSet: NSMutableOrderedSet

    init(writing: Writing) {
        self._writing = State(initialValue: writing)
        var linkIds = [Int64]()
        let vLinkIds = NSMutableOrderedSet()
        if let linkItem = DataManager.linkMapManager.query(writingId: writing.id) {
            linkIds = linkItem.dstIdList
            for id in linkItem.dstIdList {
                vLinkIds.add(id)
            }
        }
        self._linkIds = State(initialValue: linkIds)
        self._linkIdSet = State(initialValue: vLinkIds)
//        self._linkIds.wrappedValue.insert(3)
    }

    // use computed to avoid updating model while updating view

    var requiredTagMaps: [TagMap] {
        if self.tagMaps == nil {
            return self.queryTagMaps()
        }
        return self.tagMaps!
    }
    var requiredRemarks: [Remark] {
        if self.remarks == nil {
            return self.queryRemark()
        }
        return self.remarks!
    }


    var remarkEdit: Remark {
        let now = Date()
        return Remark(
                remark: self.editContent,
                target: "writing",
                targetId: self.writing.id,
                createTime: now,
                updateTime: now
        )
    }

    var tagMapEdit: TagMap {
        return TagMap(
                targetId: self.writing.id,
                tagName: self.editContent
        )
    }


    fileprivate func confirmAddRemark() throws {
        if self.editContent.isEmpty {
            throw MessageException("Remark must not be empty")
        }
        var remark = self.remarkEdit
        _ = DataManager.remarkManager.insert(model: &remark)
        self.refreshTagMaps()
    }

    fileprivate func confirmAddTag() throws {
        if self.editContent.isEmpty {
            throw MessageException("Tag must not be empty")
        }
        var model = self.tagMapEdit
        _ = DataManager.tagMapManager.insert(model: &model)
        self.refreshTagMaps()
    }

    var body: some View {
        VStack(alignment: .leading) {
            //            Group {
            Text(writing.content)
                    .frame(minHeight: 100)

            Text(DateUtils.format(writing.date, format: DateUtils.YYYY_MM_DD_HH_MM_SS))
                    .foregroundColor(.gray)
                    .italic()

            Divider()

            // The editor
            if showEditor {
                TextField(self.editorHint, text: self.$editContent)
                        .frame(height: 40)
            }
            // the editor button group
            if showEditor {
                HStack {
                    Button("Confirm", action: {
                        self.confirmEdit()
                    })


                    Divider()

                    Button("Cancel", action: {
                        self.cancelEdit()
                    })
                }
                        .frame(height: 30)
            }


            List {

                Text("Tags")
                        .font(.subheadline)
                        .bold()
                        .underline()

                if !requiredTagMaps.isEmpty {
//                    HStack {
                        ForEach(requiredTagMaps, id: \.id) { model in
                            NavigationLink(destination: WritingList(tags:[model.tagName])){
                                Text(model.tagName)
                                        .foregroundColor(.orange)
                            }
                        }
//                    }
                }
                //.alert
                if !showEditor {
                    addButton(text: "Add Tag",
                            editorHint: "tag",
                            editType: "tag", action: {
                        try self.confirmAddTag()
                    })
                }
//

                Text("Links")
                        .font(.subheadline)
                        .bold()
                        .underline()

                ForEach(self.linkIds, id: \.self) { id in
                    // if else cannot be used here
                    WritingLinkView(writing: CacheManager.instance.getWriting(id: id)!)

                }

                if !showEditor {
                    NavigationLink(destination:
                    WritingList(since: DateUtils.toWeekMondayBegin(), selected: self.$linkIdSet)) {
                        Text("Add Link")
                                .foregroundColor(.blue)
                                .underline()
                    }.onDisappear {
                        // the button is disappeared either because clicked or hide in editingMode
//                        print("Disappear,showEditor=\(self.showEditor)")
                        if !self.showEditor {
                            self.enteredLinkSelection = true
                        }
                    }.onAppear {
                        if self.enteredLinkSelection {
                            self.enteredLinkSelection = false
                            DataManager.linkMapManager.updateFor(writingId: self.writing.id, fullList: Array(self.linkIdSet.map({ $0 as! Int64})))
                            // update the list
                            self.updateLinkList()

                            // doing the update
                        }
//                        print("onAppear, linkIds = \(self.linkIds)")
                    }
                }

                Text("Remarks")
                        //                .foregroundColor(.orange)
                        .font(.subheadline)
                        .bold()
                        .underline()
                //                .background(Color.yellow)
                ForEach(requiredRemarks, id: \.id) { remark in
                    VStack {
                        Text(remark.remark)
                        Text(DateUtils.format(remark.updateTime, format: DateUtils.YYYY_MM_DD_HH_MM_SS))
                                .foregroundColor(.gray)
                                .italic()

                    }
                }


                if !showEditor {
                    addButton(text: "Add Remark",
                            editorHint: "remark",
                            editType: "remark", action: {
                        try self.confirmAddRemark()
                    })
                }

            }.alert(isPresented: self.$showAlert) {
                Alert(title: Text(self.alertTitle), message: Text(self.alertContent)
                        , dismissButton: Alert.Button.cancel(Text("OK")) {
                    self.showAlert = false
                }
                )
            }

            //            }
            Spacer()
        }
    }

    struct WritingLinkView: View {
        let writing: Writing

        var content: String {
            return self.writing.content
        }

        init(writing: Writing) {
            self.writing = writing
        }

        var body: some View {
            NavigationLink(destination: WritingDetailView(writing: self.writing)) {
                // at most 20 characters
                Text(self.content.count > 20 ?
                        (self.content[..<self.content.index(self.content.startIndex, offsetBy: 17)] + "...") :
                        self.content)
            }
        }
    }


//    private func writingLink(id: Int64) -> some View {
////        if
//        if let writing = CacheManager.instance.getWriting(id: id) {
////        {
//            return
//        } else {
//            return NavigationLink(destination: Text("")) {
//                Text("Error: \(id) removed")
//                        .foregroundColor(.red)
//            }
//        }
////        }else{
////            return EmptyView()
////        }
//    }

    func addButton(text: String, editorHint: String, editType: String
            , action: @escaping EditorAction = {
    }) -> some  View {
        Button(action: {
            self.setEditorShown(hint: editorHint, editType: editType, action: action)
        }) {
            Text(text)
                    .foregroundColor(.blue)
                    .underline()
        }
    }

    func setEditorShown(hint: String, initialContent: String = "", editType: String
            , action: @escaping EditorAction = {
    }) {
        self.editorHint = hint
        self.editContent = initialContent
        self.editType = editType
        self.editConfirmAction = action
        self.showEditor = true
    }

    func confirmEdit() {
        do {
            try self.editConfirmAction()
            self.showEditor = false
        } catch {
            let msg = (error is MessageException) ? (error as! MessageException).localizedDescription : error.localizedDescription
            self.setShowAlert(message: "Cannot complete action:\(msg)")
        }

    }


    func cancelEdit() {
        self.showEditor = false
    }

    func setShowAlert(title: String = "Error", message: String) {
        self.alertTitle = title
        self.alertContent = message
        self.showAlert = true
    }


    func refreshRemark() {
        self.remarks = self.queryRemark()
    }

    func refreshTagMaps() {
        self.tagMaps = self.queryTagMaps()
    }

    func queryRemark() -> [Remark] {
        DataManager.remarkManager.query(writingId: writing.id)
    }

    func queryTagMaps() -> [TagMap] {
        DataManager.tagMapManager.query(writingId: writing.id)
    }

    func updateLinkList() {
        var linkIds = [Int64]()
        if let linkItem = DataManager.linkMapManager.query(writingId: self.writing.id) {
            linkIds = linkItem.dstIdList
        }
        self.linkIds = linkIds
    }
}

struct WritingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WritingDetailView(writing: Writing(id: 1, content: "Hash code", date: Date()))
        }
    }
}
