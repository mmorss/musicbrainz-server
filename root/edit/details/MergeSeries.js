/*
 * @flow
 * Copyright (C) 2020 MetaBrainz Foundation
 *
 * This file is part of MusicBrainz, the open internet music database,
 * and is licensed under the GPL version 2, or (at your option) any
 * later version: http://www.gnu.org/licenses/gpl-2.0.txt
 */

import React from 'react';

import SeriesList from '../../components/list/SeriesList';

type MergeSeriesEditT = {
  ...EditT,
  +display_data: {
    +new: SeriesT,
    +old: $ReadOnlyArray<SeriesT>,
  },
};

const MergeSeries = ({edit}: {+edit: MergeSeriesEditT}) => (
  <table className="details merge-series">
    <tr>
      <th>{l('Merge:')}</th>
      <td>
        <SeriesList series={edit.display_data.old} />
      </td>
    </tr>
    <tr>
      <th>{l('Into:')}</th>
      <td>
        <SeriesList series={[edit.display_data.new]} />
      </td>
    </tr>
  </table>
);

export default MergeSeries;
