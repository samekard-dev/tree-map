enum Direction {
    case h
    case v
}

class LayoutData {
    var direction: Direction = .h
    var content: [(index: Int, w: Double, h: Double)] = []
    var child: LayoutData? = nil
}

func calculateLayout(w: Double, h: Double, data: [Double], from: Int) -> LayoutData {
    
    let returnData = LayoutData()
    let dataToArea = w * h / data[from...].reduce(0.0, +)
    if w < h {
        returnData.direction = .v //縦に2つ並べる。ひとつ目はいくつかの四角（横に並べる）。二つ目は子。
    } else {
        returnData.direction = .h
    }
    let mainLength = min(w, h) //個々の長方形を並べる方向がmain
    var currentIndex = from //この値を増やしていく
    var area = data[currentIndex] * dataToArea //グループ全体の面積（増やしていく）
    var crossLength = area / mainLength //mainに直交するのがcross
    
    // セルが正方形に近いか調べている
    var cellRatio = mainLength / crossLength
    cellRatio = max(cellRatio, 1.0 / cellRatio)
    
    while currentIndex + 1 < data.count {
        let newIndex = currentIndex + 1
        let newArea = area + data[newIndex] * dataToArea
        let newCrossLength = newArea / mainLength
        var newCellRatio = data[newIndex] * dataToArea / newCrossLength / newCrossLength
        newCellRatio = max(newCellRatio, 1.0 / newCellRatio)
        
        if newCellRatio < cellRatio {
            //付け足した方が正方形に近かった
            currentIndex = newIndex
            area = newArea
            crossLength = newCrossLength
            cellRatio = newCellRatio
        } else {
            break
        }
    }
    
    switch returnData.direction {
        case .h:
            for i in from...currentIndex {
                returnData.content.append((
                    index: i, 
                    w: crossLength, 
                    h: data[i] * dataToArea / crossLength))
            }
        case .v:
            for i in from...currentIndex {
                returnData.content.append((
                    index: i, 
                    w: data[i] * dataToArea / crossLength, 
                    h: crossLength))
            }
    }
    
    if currentIndex != data.count - 1 {
        switch returnData.direction {
            case .h:
                returnData.child = calculateLayout(
                    w: w - crossLength, 
                    h: h, 
                    data: data, 
                    from: currentIndex + 1)
            case .v:
                returnData.child = calculateLayout(
                    w: w, 
                    h: h - crossLength, 
                    data: data, 
                    from: currentIndex + 1)
        }
    }
    return returnData
}

