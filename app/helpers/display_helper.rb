module DisplayHelper
	def make_card_table id = nil
		<<-"HTML".html_safe
			<table border="2" width="100%" class="#{ @series[ @card[ id ][ :series ] ][ :text ] }">
				<tr>
					<th width="80%">
						#{ @series[ @card[ id ][ :series ] ][ :name ] }
					</th>
					<th>
						#{ @card[ id ][ :cost ] }
					</th>
				</tr>
        <tr class="#{ @genre[ @card[ id ][ :genre ] ][:text] }">
          <td colspan="2" style="text-align: center; font-size: x-small;">
            #{ @genre[ @card[ id ][ :genre ] ][:name] }
          </td>
        </tr>
				<tr class="#{ @genre[ @card[ id ][ :genre ] ][:text] }">
					<td colspan="2" style="text-align: center;">
						<b>#{ @card[ id ][ :name ] }</b>
					</td>
				</tr>
			</table>
		HTML
	end
end
