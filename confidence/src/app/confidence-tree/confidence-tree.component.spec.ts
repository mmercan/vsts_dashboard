import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ConfidenceTreeComponent } from './confidence-tree.component';

describe('ConfidenceTreeComponent', () => {
  let component: ConfidenceTreeComponent;
  let fixture: ComponentFixture<ConfidenceTreeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ConfidenceTreeComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ConfidenceTreeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
