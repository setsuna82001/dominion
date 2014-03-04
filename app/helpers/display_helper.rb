module DisplayHelper
	def make_card_table id = nil
		<<-"HTML".html_safe
			<table border="2" width="100%">
				<tr>
					<th width="80%">
						#{ @series[ @card[ id ][ :series ] ][ :name ] }
					</th>
					<th>
						#{ @card[ id ][ :cost ] }
					</th>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						#{ @card[ id ][ :name ] }
					</td>
				</tr>
			</table>
		HTML
	end
end
