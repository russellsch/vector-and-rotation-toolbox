classdef QuaternionUnitTests < matlab.unittest.TestCase

methods (Test)

%%%%%%%%%
% qcomp %
%%%%%%%%%

function test_qcomp(test)

    n = 100;
    a = randunit(4, n);
    b = randunit(4, n);
    c = qcomp(a, b);
    
    c_0 = zeros(4, n);
    for k = 1:n
        c_0(:,k) = dcm2q(q2dcm(a(:,k)) * q2dcm(b(:,k)));
    end
    
    c_0 = qpos(c_0);
    c   = qpos(c);
    test.verifyEqual(sign(c(4,:)), ones(1, n));
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
end % qcomp
    
%%%%%%%%
% qinv %
%%%%%%%%

function test_qinv(test)

    n = 100;
    a = randunit(4, n);
    c = qinv(a);
    
    c_0 = zeros(4, n);
    for k = 1:n
        c_0(:,k) = dcm2q(q2dcm(a(:,k)).');
    end
    
    c_0 = qpos(c_0);
    c   = qpos(c);
    test.verifyEqual(sign(c(4,:)), ones(1, n));
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
end % qinv
        
%%%%%%%%
% qrot %
%%%%%%%%

function test_qrot(test)

    n = 100;
    a = randunit(4, n);
    b = randunit(3, n);
    c = qrot(a, b);
    
    c_0 = zeros(3, n);
    for k = 1:n
        c_0(:,k) = q2dcm(a(:,k)) * b(:,k);
    end
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
end % qrot
        
%%%%%%%%%
% qdiff %
%%%%%%%%%

function test_qdiff(test)
    
    n = 100;
    a = randunit(4, n);
    b = randunit(4, n);
    c = qdiff(a, b);
    c_0 = qcomp(a, qinv(b));
    
    test.verifyEqual(c, c_0, 'AbsTol', 10*eps);
    
    theta   = qerr(a, b);
    theta_0 = q2aa(c_0);
    
    test.verifyEqual(theta, theta_0, 'AbsTol', 10*eps);
    
end % qdiff

%%%%%%%%%%%
% qinterp %
%%%%%%%%%%%

function test_qinterp(test)

    r = randunit(3);
    w = randn();
    t = 0:1:10;
    n = length(t);
    q = zeros(4, n);
    for k = 1:n
        q(:,k) = aa2q(r, w*t(k));
    end
    
    % Form the truth.
    ti   = 0:0.5:10;
    qi_0 = zeros(4, length(ti));
    for k = 1:length(ti)
        qi_0(:,k) = aa2q(r, w*ti(k));
    end
    
    qi = qinterp(t, q, ti);
    
    test.verifyEqual(qi, qi_0, 'AbsTol', 10*eps);
    
end % qinterp
        
%%%%%%%%
% qdot %
%%%%%%%%

function test_qdot(test)

    r = [1; 0; 0];%randunit(3);
    w = 1;%randn();
    t = 0:0.1:10;
    n = length(t);
    
    q_0 = zeros(4, n);
    for k = 1:n
        q_0(:,k) = aa2q(r, w*t(k));
    end
    
    q = [q_0(:,1), zeros(4, n-1)];
    for k = 2:n
        dt  = (t(k) - t(k-1));
        qd1 = qdot(q(:,k-1),              w * r, 0.5);
        qd2 = qdot(q(:,k-1) + 0.5*dt*qd1, w * r, 0.5);
        qd3 = qdot(q(:,k-1) + 0.5*dt*qd2, w * r, 0.5);
        qd4 = qdot(q(:,k-1) +     dt*qd3, w * r, 0.5);
        qd  = 1/6 * (qd1 + 2*qd2 + 2*qd3 + qd4);
        q(:,k) = q(:,k-1) + qd * dt;
    end
    max(q(:) - q_0(:))
    test.verifyEqual(q, q_0, 'AbsTol', 1e-6);
    
end % qdot
    
%%%%%%%%%%%
% grpcomp %
%%%%%%%%%%%

function test_grpcomp(test)
    
    a  = 0;
    f  = 1;
    qa = randunit(4);
    qb = randunit(4);
    pa = q2grp(qa, a, f);
    pb = q2grp(qb, a, f);
    p = grpcomp(pa, pb, a, f);
    p_0     = q2grp(qcomp(qa, qb), a, f);
    p_0_alt = bsxfun(@times, -1./vmag2(p_0), p_0);
    
    tol = 1e-12;
    test.verifyTrue(  all(abs(p - p_0)     < tol, 1) ...
                    | all(abs(p - p_0_alt) < tol, 1));

end % grpcomp

end % methods

end % class
