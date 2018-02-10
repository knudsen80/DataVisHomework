Sub StockMarket()

    For Each ws In Worksheets
     
    'Create headers for new table
    
        ws.Range("I1").Value = "Ticker"
        ws.Range("J1").Value = "Yearly Change"
        ws.Range("K1").Value = "Percent Change"
        ws.Range("L1").Value = "Total Stock Volume"
        
    'Formatting
    
        ws.Range("C:F").NumberFormat = "0.00"
        ws.Range("G:G").NumberFormat = "#,###"
        ws.Range("J:J").NumberFormat = "0.00"
        ws.Range("K:K").NumberFormat = "0.00%"
        ws.Range("L:L").NumberFormat = "#,###"
    
    'Initialization
    
        Dim LastRow As Long
        LastRow = ws.Cells(2, 1).End(xlDown).Row
        
        Dim StockCount As Long
        StockCount = 1
        
        Dim LastRowTable As Long
        LastRowTable = ws.Cells(2, 9).End(xlDown).Row
        
        Dim PriceStart As Double
        Dim PriceEnd As Double
        
        Dim TotalStockVolume As Double
        TotalStockVolume = 0
    
    'Fill in first three columns of table
     
        For i = 2 To LastRow
        
            If i = 2 Then   'To avoid referencing top row (bc of how I wrote code)
            
                ws.Cells(1 + StockCount, 9).Value = ws.Cells(i, 1).Value
                
                PriceStart = ws.Cells(i, 3).Value
                StockCount = StockCount + 1
                
            ElseIf ws.Cells(i - 1, 1).Value <> ws.Cells(i, 1).Value Then
            
                ws.Cells(1 + StockCount, 9).Value = ws.Cells(i, 1).Value
            
                PriceEnd = ws.Cells(i - 1, 6).Value
                
                'Display yearly price change
                ws.Cells(StockCount, 10).Value = PriceEnd - PriceStart
                
                'Display yearly percentage change
                If (PriceStart = 0 Or PriceEnd = 0) Then
                    ws.Cells(StockCount, 11).Value = 0 'To handle situation with no price date (i.e. PLNT) since this displays a crazy high percentage otherwise
                Else
                    ws.Cells(StockCount, 11).Value = (PriceEnd / PriceStart) - 1
                End If
                
                PriceStart = ws.Cells(i, 3).Value
                StockCount = StockCount + 1
                
            ElseIf i = LastRow Then 'This is sloppy on my part, but necessary bc of how I structured code above
                
                PriceEnd = ws.Cells(i, 6).Value
                
                'Display yearly price change
                ws.Cells(StockCount, 10).Value = PriceEnd - PriceStart
                
                'Display yearly percentage change
                If (PriceStart = 0 Or PriceEnd = 0) Then
                    ws.Cells(StockCount, 11).Value = 0 'To handle situation with no price date (i.e. PLNT)
                Else
                    ws.Cells(StockCount, 11).Value = (PriceEnd / PriceStart) - 1
                End If
                
            End If
            
        Next i
        
    'Fill in Total Stock Volume
    
        StockCount = 1
    
        For i = 2 To LastRow
            
            If ws.Cells(i + 1, 1).Value = ws.Cells(i, 1) Then
                TotalStockVolume = TotalStockVolume + ws.Cells(i, 7)
            End If
            
            If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1) Then
                TotalStockVolume = TotalStockVolume + ws.Cells(i, 7)
                ws.Cells(1 + StockCount, 12).Value = TotalStockVolume
                StockCount = StockCount + 1
                TotalStockVolume = 0
            End If
            
        Next i
        
    'Format Yearly Change column
    
        For i = 2 To LastRowTable
            If ws.Cells(i, 10).Value > 0 Then
                ws.Cells(i, 10).Interior.Color = RGB(0, 255, 0)
            ElseIf ws.Cells(i, 10).Value < 0 Then
                ws.Cells(i, 10).Interior.Color = RGB(255, 0, 0)
            End If
        Next i
    
    'Additional work for Hard challenge is below
    
    'Create headers for new table
    
        ws.Range("O2").Value = "Greatest % Increase"
        ws.Range("O3").Value = "Greatest % Decrease"
        ws.Range("O4").Value = "Greatest Total Volume"
        ws.Range("P1").Value = "Ticker"
        ws.Range("Q1").Value = "Value"
        
    'Formatting
        ws.Range("Q2:Q3").NumberFormat = "0.00%"
        ws.Range("Q4").NumberFormat = "#,###"
        
    'Initialization
        Dim MaxUp As Double
        Dim MaxDown As Double
        Dim MaxVolume As Double
        
        Dim TickerMaxUp As String
        Dim TickerMaxDown As String
        Dim TickerMaxVolume As String
        
    'Code is below
        MaxUp = ws.Cells(2, 11).Value
        MaxDown = ws.Cells(2, 11).Value
        MaxVolume = ws.Cells(2, 12).Value
        
        For i = 3 To LastRowTable
        
            If ws.Cells(i, 11).Value > MaxUp Then
                MaxUp = ws.Cells(i, 11).Value
                TickerMaxUp = ws.Cells(i, 9).Value
            ElseIf ws.Cells(i, 11).Value < MaxDown Then
                MaxDown = ws.Cells(i, 11).Value
                TickerMaxDown = ws.Cells(i, 9).Value
            End If
            
            If ws.Cells(i, 12).Value > MaxVolume Then
                MaxVolume = ws.Cells(i, 12).Value
                TickerMaxVolume = ws.Cells(i, 9).Value
            End If
                
        Next i
        
     'Fill in the table
        ws.Cells(2, 17).Value = MaxUp
        ws.Cells(3, 17).Value = MaxDown
        ws.Cells(4, 17).Value = MaxVolume
        ws.Cells(2, 16).Value = TickerMaxUp
        ws.Cells(3, 16).Value = TickerMaxDown
        ws.Cells(4, 16).Value = TickerMaxVolume
    
    'Auto-fit so that column headers and row labels are legible
        ws.Columns("A:Q").AutoFit
    
    Next ws

End Sub


