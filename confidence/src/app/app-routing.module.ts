import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ConfidenceTreeComponent } from './confidence-tree/confidence-tree.component';
import { DashboardComponent } from './dashboard/dashboard.component';
const routes: Routes = [
  {
    path: '',
    component: DashboardComponent,
  }, {
    path: 'tree',
    component: ConfidenceTreeComponent,
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
